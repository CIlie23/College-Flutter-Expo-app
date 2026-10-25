import { eq } from 'drizzle-orm';
import { useLiveQuery } from 'drizzle-orm/expo-sqlite';
import { create } from 'zustand';
import type { Building, Entrance, EntranceSurvey } from './contract/contract';
import { ME } from './contract/fixtures';
import { db } from './db/db';
import { buildings, entrances } from './db/schema';

// ---------------------------------------------------------------------------
// The data lives in SQLite. Screens read it with live queries: when a write
// changes a table, every screen reading that table re-renders by itself.
// ---------------------------------------------------------------------------

export function useEntrances(): Entrance[] {
  return useLiveQuery(db.select().from(entrances)).data;
}

/** undefined while SQLite answers the first time, null when there is no such row. */
export function useEntrance(id: string): Entrance | null | undefined {
  const { data, updatedAt } = useLiveQuery(
    db.select().from(entrances).where(eq(entrances.id, id)),
    [id],
  );
  return updatedAt ? (data[0] ?? null) : undefined;
}

export function useBuilding(id: string): Building | undefined {
  return useLiveQuery(db.select().from(buildings).where(eq(buildings.id, id)), [id]).data[0];
}

/** The survey goes to SQLite: it survives a restart, and waits for week 4's push. */
export async function submitSurvey(id: string, survey: EntranceSurvey) {
  const now = new Date().toISOString();
  await db
    .update(entrances)
    .set({
      ...survey,
      surveyStatus: 'submitted',
      surveyedBy: ME,
      surveyedAt: now,
      updatedAt: now,
      syncState: 'pending', // the office has not seen this version yet
      lastError: null,
    })
    .where(eq(entrances.id, id));
}

// ---------------------------------------------------------------------------
// Everything that is not data — where the phone is, which way it faces, the
// network — is client state, in one Zustand store. Steps 7 and 12 fill it.
// ---------------------------------------------------------------------------

export type Fix = { lat: number; lng: number; accuracy: number | null; at: string };

type FieldState = {
  fix: Fix | null;
  heading: number | null;
  setFix: (fix: Fix | null) => void;
  setHeading: (heading: number | null) => void;
};

export const useField = create<FieldState>()((set) => ({
  fix: null,
  heading: null,
  setFix: (fix) => set({ fix }),
  setHeading: (heading) => set({ heading }),
}));