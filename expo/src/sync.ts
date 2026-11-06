import { QueryClient } from '@tanstack/react-query';
import { and, eq, inArray } from 'drizzle-orm';
import { addNetworkStateListener } from 'expo-network';
import { FirebaseError } from 'firebase/app';
import { getDownloadURL, ref, uploadBytes } from 'firebase/storage';
import { useEffect } from 'react';
import { AppState } from 'react-native';
import { ZodError } from 'zod';
import { pins, surveys } from './cloud';
import { type Entrance, EntranceSurvey } from './contract/contract';
import { db } from './db/db';
import { photos } from './db/schema';
import { storage } from './firebase';
import { markSent, outbox, savePins } from './store';
import { MAX_TRIES, isRetryable, markSyncTime, nextDelay } from './syncStatus';

/** Server state: what the cloud says right now. Screens still read SQLite. */
export const queryClient = new QueryClient();
export const myPinsKey = (uid: string) => ['pins', uid] as const;

export function useSync(uid: string) {
  useEffect(() => {
    const stop = pins.watchMine(
      uid,
      (list: Entrance[]) => {
        queryClient.setQueryData(myPinsKey(uid), list);
        savePins(list)
          .then(() => markSyncTime('pull'))
          .catch((e) => console.warn('savePins', e));
      },
      (e) => console.warn('pins listener', e),
    );
    return stop;
  }, [uid]);

  useEffect(() => {
    // Foreground and network-back are events, not a loop: they reset the
    // backoff and try at once.
    const push = () => {
      void retryNow(uid).catch((e) => console.warn('pushSurveys', e));
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
      resetRetries();
    };
  }, [uid]);
}

// ---- automatic retries (the policy is written at the top of sync-status.tsx) ----
let tries = 0;
let timer: ReturnType<typeof setTimeout> | null = null;

function resetRetries() {
  tries = 0;
  if (timer) clearTimeout(timer);
  timer = null;
}

function scheduleRetry(uid: string) {
  if (timer || tries >= MAX_TRIES) return;
  tries += 1;
  timer = setTimeout(() => {
    timer = null;
    void pushSurveys(uid).catch((e) => console.warn('retry', e));
  }, nextDelay(tries));
}

/** A person or the OS asked for a push: forget the backoff and go. */
export function retryNow(uid: string, only?: string) {
  resetRetries();
  return pushSurveys(uid, only);
}

let pushing = false;

/**
 * The outbox push: every unsent survey goes up as surveys/{entranceId} with
 * setDoc (idempotent: the id is the survey's own). Offline, setDoc waits until
 * the network is back; SQLite keeps the survey meanwhile. `only` pushes one row.
 */
export async function pushSurveys(uid: string, only?: string) {
  if (pushing) return; // one push at a time
  pushing = true;
  let retryable = false;
  try {
    for (const e of (await outbox()).filter((r) => !only || r.id === only)) {
      try {
        await surveys.push({
          ...EntranceSurvey.parse(e),
          id: e.id,
          surveyStatus: e.surveyStatus,
          surveyedBy: uid,
          surveyedAt: e.surveyedAt ?? e.updatedAt,
          updatedAt: e.updatedAt,
        });
        await markSent(e.id, e.updatedAt, null);
        markSyncTime('push');
      } catch (err) {
        const code =
          err instanceof FirebaseError ? err.code : err instanceof ZodError ? 'invalid-survey' : String(err);
        await markSent(e.id, e.updatedAt, code);
        if (isRetryable(code)) retryable = true;
      }
    }
    if (!only && process.env.EXPO_PUBLIC_UPLOAD_PHOTOS === '1') await pushPhotos(uid);
  } finally {
    pushing = false;
  }
  if (retryable) scheduleRetry(uid);
  else if (!only) resetRetries();
}

/** Every photo not uploaded yet goes to photos/{uid}/{entranceId}/{photoId}.jpg. */
async function pushPhotos(uid: string) {
  const waiting = await db.select().from(photos).where(inArray(photos.uploadState, ['pending', 'failed']));
  for (const p of waiting) {
    try {
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