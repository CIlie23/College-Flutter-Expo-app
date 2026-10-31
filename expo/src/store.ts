import { eq } from 'drizzle-orm';
import { useLiveQuery } from 'drizzle-orm/expo-sqlite';
import { create } from 'zustand';
import type { Building, Entrance, EntranceSurvey } from './contract/contract';
import { ME } from './contract/fixtures';
import { db } from './db/db';
import { buildings, entrances } from './db/schema';
import * as Crypto from 'expo-crypto';
export type EntranceRow = typeof entrances.$inferSelect;

// ---------------------------------------------------------------------------
// The data lives in SQLite. Screens read it with live queries: when a write
// changes a table, every screen reading that table re-renders by itself.
// ---------------------------------------------------------------------------

export function useEntrances(): Entrance[] {
  return useLiveQuery(db.select().from(entrances)).data;
}

/** undefined while SQLite answers the first time, null when there is no such row. */
export function useEntrance(id: string): EntranceRow | null | undefined {
  const { data, updatedAt } = useLiveQuery(
    db.select().from(entrances).where(eq(entrances.id, id)),
    [id],
  );
  return updatedAt ? (data[0] ?? null) : undefined;
}

/** Exercise 1: the new column, written like any other. */
export async function markOpened(id: string) {
  await db.update(entrances).set({ openedAt: new Date().toISOString() }).where(eq(entrances.id, id));
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
  recent: string[]; // exercise 5: the last five entrances opened, newest first
  setFix: (fix: Fix | null) => void;
  setHeading: (heading: number | null) => void;
  openRecent: (id: string) => void;
};

export const useField = create<FieldState>()((set) => ({
  fix: null,
  heading: null,
  recent: [],
  setFix: (fix) => set({ fix }),
  setHeading: (heading) => set({ heading }),
  // Exercise 5: a NEW array every time. s.recent.push(id) would change the old
  // array in place: same reference, so Zustand sees "no change" and nothing re-renders.
  openRecent: (id) => set((s) => ({ recent: [id, ...s.recent.filter((x) => x !== id)].slice(0, 5) })),
}));

export async function addMissedEntrance(at: { lat: number; lng: number }): Promise<string> {
  const now = new Date().toISOString();
  const buildingId = Crypto.randomUUID();
  const entranceId = Crypto.randomUUID();
  await db.insert(buildings).values({
    id: buildingId,
    createdAt: now,
    updatedAt: now,
    label: 'New building',
    comment: 'Added in the field: not on the office map.',
    syncState: 'pending',
  });
  await db.insert(entrances).values({
    id: entranceId,
    createdAt: now,
    updatedAt: now,
    buildingId,
    lat: at.lat,
    lng: at.lng,
    street: '?', // the survey asks for the real address
    number: '?',
    entranceName: 'Sc. 1',
    coordsConfirmed: true, // the pin is where the worker stands: at the door
    correctedLat: null,
    correctedLng: null,
    addressConfirmed: false,
    stories: null,
    flats: null,
    elevators: null,
    yearBuilt: null,
    groundFloorCommercial: null,
    comment: null,
    surveyStatus: 'in_progress',
    surveyedBy: null,
    surveyedAt: null,
    syncState: 'pending',
  });
  return entranceId;
}

/**
 * Exercise 3 — a derived selector: a component that reads useField(fixQuality)
 * re-renders when the quality changes, not on every new fix.
 */
export const fixQuality = (s: FieldState): 'none' | 'good' | 'rough' =>
  s.fix === null ? 'none' : (s.fix.accuracy ?? Number.POSITIVE_INFINITY) <= 10 ? 'good' : 'rough';