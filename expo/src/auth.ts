import type { FirebaseApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';

/** The web: Firebase keeps the session in the browser (IndexedDB) by itself. */
export const makeAuth = (app: FirebaseApp) => getAuth(app);