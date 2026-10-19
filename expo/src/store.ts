import { useSyncExternalStore } from 'react';
import type { Entrance, EntranceSurvey } from './contract/contract';
import { ME, entrances as fixtureEntrances } from './contract/fixtures';

// One module-level store: a variable, a set of listeners, and React's own
// useSyncExternalStore to subscribe. No provider, no library; any screen that
// calls useEntrances() re-renders when a survey is submitted.
let entrances: Entrance[] = fixtureEntrances;
const listeners = new Set<() => void>();

function subscribe(listener: () => void) {
  listeners.add(listener);
  return () => {
    listeners.delete(listener);
  };
}

export function useEntrances(): Entrance[] {
  return useSyncExternalStore(subscribe, () => entrances);
}

export function useEntrance(id: string): Entrance | undefined {
  return useEntrances().find((e) => e.id === id);
}

export function submitSurvey(id: string, survey: EntranceSurvey) {
  const now = new Date().toISOString();
  entrances = entrances.map((e) =>
    e.id === id
      ? {
          ...e,
          ...survey,
          surveyStatus: 'submitted',
          surveyedBy: ME,
          surveyedAt: now,
          updatedAt: now,
        }
      : e,
  );
  for (const listener of listeners) listener();
}