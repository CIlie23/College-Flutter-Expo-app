import { eq } from 'drizzle-orm';
import { useLiveQuery } from 'drizzle-orm/expo-sqlite';
import * as Crypto from 'expo-crypto';
import { Directory, File, Paths } from 'expo-file-system';
import * as ImagePicker from 'expo-image-picker';
import { Platform } from 'react-native';
import { db } from './db/db';
import { type PhotoRow, photos } from './db/schema';
import { locate } from './location';
import { ensureCamera } from './permissions';
import { useField } from './store';

/** What the photo file says about itself (EXIF), as far as we read it tonight. */
export type ExifSummary = { camera: string | null; shotAt: string | null; gpsInExif: boolean };

export function readExif(exif: Record<string, unknown> | null | undefined): ExifSummary {
  const s = (k: string) => (exif?.[k] == null ? null : String(exif[k]));
  const camera = [s('Make'), s('Model')].filter(Boolean).join(' ') || null;
  return {
    camera,
    shotAt: s('DateTimeOriginal') ?? s('DateTime'), // "2026:10:20 18:41:07", local time, no zone
    gpsInExif: exif?.GPSLatitude != null,
  };
}

/**
 * Keep the picture: copy it out of the picker's cache (the system may empty
 * it) into the app's documents folder, named after the photo row's id.
 */
function keep(uri: string, id: string): string {
  if (Platform.OS === 'web') return uri; // no file system on the web: the picker gave us a data: URI
  const folder = new Directory(Paths.document, 'photos');
  folder.create({ idempotent: true, intermediates: true });
  const file = new File(folder, `${id}.jpg`);
  new File(uri).copySync(file);
  return file.uri;
}

async function save(
  entranceId: string,
  asset: ImagePicker.ImagePickerAsset,
  where: { lat: number; lng: number } | null,
  heading: number | null,
) {
  const id = Crypto.randomUUID(); // the photo's id, born on the phone (UUID v4)
  const now = new Date().toISOString();
  const row: typeof photos.$inferInsert = {
    id,
    createdAt: now,
    updatedAt: now,
    entranceId,
    fileName: `${id}.jpg`,
    remoteUrl: null,
    takenAt: now,
    lat: where?.lat ?? null,
    lng: where?.lng ?? null,
    heading,
    uploadState: 'pending', // week 5 uploads it
    reviewStatus: 'pending',
    reviewNote: null,
    reviewedBy: null,
    replacesPhotoId: null,
    syncState: 'pending',
    lastError: null,
    localUri: keep(asset.uri, id),
  };
  await db.insert(photos).values(row);
  return readExif(asset.exif);
}

/**
 * The camera: permission in context, the system camera, then a row. The row's
 * lat/lng are where the PHONE is at the shutter (the contract's meaning) — not
 * the EXIF, which the camera app may leave out, the user may strip, and the
 * photo picker removes.
 */
export async function takePhoto(entranceId: string): Promise<ExifSummary | null> {
  if (!(await ensureCamera())) return null;
  const result = await ImagePicker.launchCameraAsync({ mediaTypes: ['images'], exif: true, quality: 1 });
  if (result.canceled) return null;
  const fix = await locate().catch(() => null); // no permission or no signal: null, as the contract allows
  return save(entranceId, result.assets[0], fix, fix ? useField.getState().heading : null);
}

export function usePhotos(entranceId: string): PhotoRow[] {
  return useLiveQuery(db.select().from(photos).where(eq(photos.entranceId, entranceId)), [entranceId])
    .data;
}