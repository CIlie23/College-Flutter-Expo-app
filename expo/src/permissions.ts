import * as ImagePicker from 'expo-image-picker';
import * as Location from 'expo-location';
import { Alert, Linking, Platform } from 'react-native';

type Answer = { granted: boolean; canAskAgain: boolean };

/**
 * Ask for a permission when the user does the thing that needs it — never at
 * launch. Granted: true. Denied once: false, and the next press asks again.
 * Denied for good ("Don't allow" twice on Android 11+, or "Don't ask again"):
 * the system will not show its dialog any more, so offer the app's Settings.
 */
async function ensure(
  what: string,
  why: string,
  check: () => Promise<Answer>,
  ask: () => Promise<Answer>,
): Promise<boolean> {
  const now = await check();
  if (now.granted) return true;
  if (!now.canAskAgain) {
    offerSettings(what, why);
    return false;
  }
  const answer = await ask();
  if (answer.granted) return true;
  if (!answer.canAskAgain) offerSettings(what, why);
  return false;
}

function offerSettings(what: string, why: string) {
  if (Platform.OS === 'web') {
    // The browser keeps the choice per site: the padlock next to the address.
    globalThis.alert?.(`${what} is blocked. ${why} Allow it from the padlock in the address bar.`);
    return;
  }
  Alert.alert(`${what} is off`, `${why} You can turn it on in Settings → Permissions.`, [
    { text: 'Not now', style: 'cancel' },
    { text: 'Open Settings', onPress: () => Linking.openSettings() },
  ]);
}

export const ensureLocation = () =>
  ensure(
    'Location',
    'The field app tags your photos and new pins with where you stand.',
    Location.getForegroundPermissionsAsync,
    Location.requestForegroundPermissionsAsync,
  );

export const ensureCamera = () =>
  ensure(
    'The camera',
    'The field app photographs the entrances you survey.',
    ImagePicker.getCameraPermissionsAsync,
    ImagePicker.requestCameraPermissionsAsync,
  );