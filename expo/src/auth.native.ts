import AsyncStorage from '@react-native-async-storage/async-storage';
import type { FirebaseApp } from 'firebase/app';
import {
  getAuth,
  getReactNativePersistence,
  initializeAuth,
  type Persistence,
  type ReactNativeAsyncStorage,
} from 'firebase/auth';

// firebase 13.1.0 exports getReactNativePersistence from its React Native
// build only, and its TypeScript types forget it (firebase-js-sdk #8332).
declare module 'firebase/auth' {
  export function getReactNativePersistence(storage: ReactNativeAsyncStorage): Persistence;
}

/**
 * Android and iOS: without a persistence, the session lives in memory and
 * every restart signs the worker out. AsyncStorage keeps it on the phone.
 */
export function makeAuth(app: FirebaseApp) {
  try {
    return initializeAuth(app, { persistence: getReactNativePersistence(AsyncStorage) });
  } catch {
    return getAuth(app); // Fast Refresh: already initialized
  }
}