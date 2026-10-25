import * as Crypto from 'expo-crypto';
import * as SecureStore from 'expo-secure-store';
import Storage from 'expo-sqlite/kv-store';
import { useEffect, useState } from 'react';
import { Platform } from 'react-native';

const TOKEN = 'field.token';
const LAST_TAB = 'field.lastTab';

/**
 * A secret belongs in the secure store (Android Keystore / iOS Keychain),
 * never in SQLite or plain storage. Week 4 puts the real sign-in token here;
 * tonight a placeholder shows where it goes and that it survives a restart.
 */
async function loadToken(): Promise<string> {
  // expo-secure-store has no web version: the browser has no keystore for us.
  const web = Platform.OS === 'web';
  const get = (k: string) => (web ? Storage.getItem(k) : SecureStore.getItemAsync(k));
  const set = (k: string, v: string) => (web ? Storage.setItem(k, v) : SecureStore.setItemAsync(k, v));
  const saved = await get(TOKEN);
  if (saved) return saved;
  const token = `placeholder-${Crypto.randomUUID()}`;
  await set(TOKEN, token);
  return token;
}

export function useToken(): string | null {
  const [token, setToken] = useState<string | null>(null);
  useEffect(() => {
    loadToken().then(setToken);
  }, []);
  return token;
}

/** Preferences are not secret and not data: a small key–value store is enough. */
export const lastTab = {
  get: () => Storage.getItemSync(LAST_TAB),
  set: (path: string) => Storage.setItemSync(LAST_TAB, path),
};