import { QueryClient } from '@tanstack/react-query';
import { and, eq, inArray } from 'drizzle-orm';
import { addNetworkStateListener } from 'expo-network';
import { FirebaseError } from 'firebase/app';
import { getDownloadURL, ref, uploadBytes } from 'firebase/storage';
import { useEffect } from 'react';
import { AppState } from 'react-native';
import { pins, surveys } from './cloud';
import { type Entrance, EntranceSurvey } from './contract/contract';
import { db } from './db/db';
import { photos } from './db/schema';
import { storage } from './firebase';
import { markSent, outbox, savePins } from './store';

/** Server state: what the cloud says right now. Screens still read SQLite. */
export const queryClient = new QueryClient();
export const myPinsKey = (uid: string) => ['pins', uid] as const;

/**
 * The pull, while a worker is signed in: one Firestore listener on my pins.
 * Every snapshot goes to SQLite (the truth on the phone) and into TanStack
 * Query's cache with setQueryData, so the banner shows the cloud's count
 * without a second request.
 */
export function useSync(uid: string) {
  useEffect(() => {
    const stop = pins.watchMine(
      uid,
      (list: Entrance[]) => {
        queryClient.setQueryData(myPinsKey(uid), list);
        savePins(list).catch((e) => console.warn('savePins', e));
      },
      (e) => console.warn('pins listener', e),
    );
    return stop; // signing out unmounts the hook: the listener stops
  }, [uid]);

  useEffect(() => {
    const push = () => {
      void pushSurveys(uid).catch((e) => console.warn('pushSurveys', e));
    };
    push();
    const foreground = AppState.addEventListener('change', (state) => {
      if (state === 'active') push();
    });
    const network = addNetworkStateListener((state) => {
      if (state.isConnected) push();
    });
    return () => {
      foreground.remove();
      network.remove();
    };
  }, [uid]);
}

let pushing = false;

/**
 * The outbox push: every unsent survey goes up as surveys/{entranceId} with
 * setDoc. The id is the survey's own, so a second push (the app was killed
 * before it heard "ok") overwrites the same document: idempotent. Offline,
 * setDoc waits until the network is back; SQLite keeps the survey meanwhile.
 */
export async function pushSurveys(uid: string) {
  if (pushing) return; // one push at a time
  pushing = true;
  try {
    for (const e of await outbox()) {
      try {
        await surveys.push({
          // The contract's survey schema picks the surveyed fields (and checks them).
          ...EntranceSurvey.parse(e),
          id: e.id,
          surveyStatus: e.surveyStatus,
          surveyedBy: uid,
          surveyedAt: e.surveyedAt ?? e.updatedAt,
          updatedAt: e.updatedAt,
        });
        await markSent(e.id, e.updatedAt, null);
      } catch (err) {
        // permission-denied: the rules refused it (the pin is no longer mine).
        await markSent(e.id, e.updatedAt, err instanceof FirebaseError ? err.code : String(err));
      }
    }
    // Step 11 (optional): the photos, when the project has Storage.
    if (process.env.EXPO_PUBLIC_UPLOAD_PHOTOS === '1') await pushPhotos(uid);
  } finally {
    pushing = false;
  }
}

/** Every photo not uploaded yet goes to photos/{uid}/{entranceId}/{photoId}.jpg. */
async function pushPhotos(uid: string) {
  const waiting = await db.select().from(photos).where(inArray(photos.uploadState, ['pending', 'failed']));
  for (const p of waiting) {
    try {
      // fetch reads a file:// path on the phone and the data: URI on the web alike.
      const blob = await (await fetch(p.localUri)).blob();
      const file = ref(storage, `photos/${uid}/${p.entranceId}/${p.id}.jpg`);
      await uploadBytes(file, blob, { contentType: blob.type || 'image/jpeg' });
      const remoteUrl = await getDownloadURL(file);
      await db.update(photos).set({ uploadState: 'uploaded', remoteUrl, lastError: null }).where(eq(photos.id, p.id));
    } catch (err) {
      const error = err instanceof FirebaseError ? err.code : String(err);
      await db
        .update(photos)
        .set({ uploadState: 'failed', lastError: error })
        .where(and(eq(photos.id, p.id), eq(photos.uploadState, p.uploadState)));
    }
  }
}