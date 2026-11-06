import { count } from 'drizzle-orm';
import type { ExpoSQLiteDatabase } from 'drizzle-orm/expo-sqlite';
import { buildings as fixtureBuildings } from '../contract/fixtures';
import * as schema from './schema';

/**
 * First launch only: copy the office's buildings into the empty table. The
 * entrances no longer come from the fixtures: since week 4 they are the pins
 * the cloud assigns to the signed-in worker (sync.ts).
 */
export async function seedIfEmpty(db: ExpoSQLiteDatabase<typeof schema>) {
  const [{ n }] = await db.select({ n: count() }).from(schema.buildings);
  if (n > 0) return;
  // They came from the office, so the office already has them: synced.
  await db
    .insert(schema.buildings)
    .values(fixtureBuildings.map((b) => ({ ...b, syncState: 'synced' as const })));
}