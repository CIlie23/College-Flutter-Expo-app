import * as Location from 'expo-location';
import { useEffect } from 'react';
import { Platform } from 'react-native';
import { ensureLocation } from './permissions';
import { type Fix, useField } from './store';

/** 0 ≤ h < 360, whatever the sensor said (-90 → 270, 360 → 0). */
export const normalizeHeading = (h: number) => ((h % 360) + 360) % 360;

const POINTS = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
export const compassPoint = (h: number) => POINTS[Math.round(normalizeHeading(h) / 45) % 8];

/**
 * One fix, now: ask for the permission in context, then a single position
 * (cheaper on the battery than a subscription). Kept in the store for the
 * photo and the missed-building pin.
 */
export async function locate(): Promise<Fix | null> {
  if (!(await ensureLocation())) return null;
  const p = await Location.getCurrentPositionAsync({ accuracy: Location.Accuracy.High });
  const fix: Fix = {
    lat: p.coords.latitude,
    lng: p.coords.longitude,
    accuracy: p.coords.accuracy, // metres, the radius of 68 % confidence
    at: new Date(p.timestamp).toISOString(),
  };
  useField.getState().setFix(fix);
  return fix;
}

/**
 * Follow the compass while the calling screen is on: subscribe on mount, stop
 * on unmount. The compass needs the location permission, so start once allowed.
 */
export function useHeading(allowed: boolean) {
  useEffect(() => {
    if (!allowed || Platform.OS === 'web') return; // expo-location has no compass on the web
    let subscription: Location.LocationSubscription | undefined;
    let stopped = false;
    Location.watchHeadingAsync((h) => {
      // trueHeading is -1 until the phone knows where it is; magHeading always comes.
      const raw = h.trueHeading >= 0 ? h.trueHeading : h.magHeading;
      useField.getState().setHeading(normalizeHeading(raw));
    }).then((s) => {
      if (stopped) s.remove();
      else subscription = s;
    });
    return () => {
      stopped = true;
      subscription?.remove();
    };
  }, [allowed]);
}