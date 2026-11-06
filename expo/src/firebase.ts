import { getApp, getApps, initializeApp } from 'firebase/app';
import { useEffect, useState } from 'react';
import { makeAuth } from './auth';
import { Platform } from 'react-native';
import { connectAuthEmulator, onAuthStateChanged, type User } from 'firebase/auth';
import { connectFirestoreEmulator, getFirestore } from 'firebase/firestore';
import { connectStorageEmulator, getStorage } from 'firebase/storage';

// The Web app's config from the Firebase console, read from expo/.env.
// EXPO_PUBLIC_ variables are copied into the app's JavaScript when Metro
// bundles it: they are not secrets (the security rules are the protection).
const config = {
  apiKey: process.env.EXPO_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.EXPO_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.EXPO_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.EXPO_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.EXPO_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.EXPO_PUBLIC_FIREBASE_APP_ID,
};

// Fast Refresh re-runs this file: reuse the app instead of creating a second one.
const fresh = getApps().length === 0;
export const app = fresh ? initializeApp(config) : getApp();
export const auth = makeAuth(app);
export const firestore = getFirestore(app);
export const storage = getStorage(app);

// Step 11, no card: the Local Emulator Suite on your PC instead of Google's
// servers. The browser finds them on localhost; the Android emulator reaches
// your PC as 10.0.2.2; a phone needs your PC's LAN address (EXPO_PUBLIC_EMULATOR_HOST).
if (fresh && process.env.EXPO_PUBLIC_USE_EMULATORS === '1') {
  const host = Platform.OS === 'web' ? 'localhost' : (process.env.EXPO_PUBLIC_EMULATOR_HOST ?? '10.0.2.2');
  connectAuthEmulator(auth, `http://${host}:9099`, { disableWarnings: true });
  connectFirestoreEmulator(firestore, host, 8080);
  connectStorageEmulator(storage, host, 9199);
}

/** undefined while Firebase reads the saved session, then the user or null. */
export function useUser(): User | null | undefined {
  const [user, setUser] = useState<User | null | undefined>(undefined);
  useEffect(() => onAuthStateChanged(auth, setUser), []);
  return user;
}