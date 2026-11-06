import AsyncStorage from '@react-native-async-storage/async-storage';
import { create } from 'zustand';

// ---- retry policy numbers (the policy itself is written in sync-status.tsx) ----
export const MAX_TRIES = 6;
export const nextDelay = (n: number) => Math.min(10_000 * 2 ** (n - 1), 300_000); // 10 s, 20 s, 40 s … 5 min

/** Errors that waiting cannot fix: someone has to act. */
const NEVER_RETRY = [
  'permission-denied',
  'unauthenticated',
  'invalid-argument',
  'failed-precondition',
  'not-found',
  'already-exists',
  'invalid-survey',
];
export const isRetryable = (code: string) => !NEVER_RETRY.includes(code);

/** The code is for the developer; the worker reads a sentence and a next step. */
export function friendlyError(code: string | null): { what: string; todo: string } {
  switch (code) {
    case 'permission-denied':
      return {
        what: 'The office no longer accepts this survey from you: the entrance was probably given to someone else.',
        todo: 'Do not retry. Tell the office, they can assign it back or remove it.',
      };
    case 'unauthenticated':
      return { what: 'You were signed out.', todo: 'Sign in again, then press Retry.' };
    case 'unavailable':
    case 'network-request-failed':
    case 'deadline-exceeded':
      return {
        what: 'The cloud could not be reached.',
        todo: 'Move to where there is signal. The app tries again by itself.',
      };
    case 'resource-exhausted':
      return { what: 'The cloud is too busy right now.', todo: 'Wait a few minutes, it tries again by itself.' };
    case 'invalid-survey':
      return {
        what: 'This survey has a missing or wrong answer.',
        todo: 'Open the entrance, fix the survey and submit it again.',
      };
    default:
      return {
        what: 'Something went wrong while sending.',
        todo: 'Press Retry. If it keeps failing, tell the office.',
      };
  }
}

// ---- when did we last hear from the cloud ----
type Times = { pull: string | null; push: string | null };
export const useSyncTimes = create<Times>()(() => ({ pull: null, push: null }));

AsyncStorage.multiGet(['sync:lastPull', 'sync:lastPush'])
  .then(([[, pull], [, push]]) =>
    // a fresher value written before the read finished wins
    useSyncTimes.setState((s) => ({ pull: s.pull ?? pull, push: s.push ?? push })),
  )
  .catch(() => {});

export function markSyncTime(kind: 'pull' | 'push') {
  const at = new Date().toISOString();
  useSyncTimes.setState(kind === 'pull' ? { pull: at } : { push: at });
  AsyncStorage.setItem(kind === 'pull' ? 'sync:lastPull' : 'sync:lastPush', at).catch(() => {});
}