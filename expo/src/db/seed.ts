import { count } from 'drizzle-orm';
import type { ExpoSQLiteDatabase } from 'drizzle-orm/expo-sqlite';
import { buildings as fixtureBuildings, entrances as fixtureEntrances } from '../contract/fixtures';
import * as schema from './schema';

/** First launch only: copy the office's fixtures into the empty tables. */
export async function seedIfEmpty(db: ExpoSQLiteDatabase<typeof schema>) {
  const [{ n }] = await db.select({ n: count() }).from(schema.entrances);
  if (n > 0) return;
  // They came from the office, so the office already has them: synced.
  await db
    .insert(schema.buildings)
    .values(fixtureBuildings.map((b) => ({ ...b, syncState: 'synced' as const })));
  await db
    .insert(schema.entrances)
    .values(fixtureEntrances.map((e) => ({ ...e, syncState: 'synced' as const })));
}