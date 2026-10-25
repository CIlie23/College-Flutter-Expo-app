import { drizzle, type ExpoSQLiteDatabase } from 'drizzle-orm/expo-sqlite';
import { migrate } from 'drizzle-orm/expo-sqlite/migrator';
import { openDatabaseAsync } from 'expo-sqlite';
import migrations from '../../drizzle/migrations';
import * as schema from './schema';
import { seedIfEmpty } from './seed';

/** The app's truth: one SQLite file, field.db, in the app's own sandbox. */
export let db: ExpoSQLiteDatabase<typeof schema>;

/**
 * Open field.db, bring it up to the latest migration, seed it on the first
 * launch. Called once, before the first screen.
 */
export async function openDb() {
  // Async on purpose: on the web the first sync call can time out while the
  // WebAssembly worker starts (expo-sqlite 58.0.13). enableChangeListener lets
  // useLiveQuery re-run a query whenever a table it reads changes.
  const sqlite = await openDatabaseAsync('field.db', { enableChangeListener: true });
  db = drizzle(sqlite, { schema });
  await migrate(db, migrations);
  await seedIfEmpty(db);
}