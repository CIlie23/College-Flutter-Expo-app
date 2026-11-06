import { QueryClientProvider } from '@tanstack/react-query';
import { DarkTheme, DefaultTheme, Stack, ThemeProvider } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { useEffect, useState } from 'react';
import { Text, useColorScheme, View } from 'react-native';
import { openDb } from '../db/db';
import { KeyboardProvider } from 'react-native-keyboard-controller';
import { SignIn } from '../components/SignIn';
import { useUser } from '../firebase';
import { queryClient, useSync } from '../sync';

function describeError(error: unknown): string {
  if (!(error instanceof Error)) return String(error);
  return error.cause instanceof Error
    ? `${error.message}: ${describeError(error.cause)}`
    : error.message;
}

export default function RootLayout() {
  const [state, setState] = useState<'opening' | 'ready' | Error>('opening');
  const user = useUser();
  useEffect(() => {
    openDb().then(
      () => setState('ready'),
      (e: Error) => setState(e),
    );
  }, []);

  if (state instanceof Error) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', padding: 24 }}>
        <Text>Could not open the database: {describeError(state)}</Text>
      </View>
    );
  }
  if (state === 'opening' || user === undefined) return null; // a few milliseconds
  // The auth-state gate: no user, no app. Signing in re-renders this layout.
  if (user === null) return <SignIn />;
  return <SignedIn uid={user.uid} />;
}

/** Everything behind the gate: the sync runs while this is on screen. */
function SignedIn({ uid }: { uid: string }) {
  const scheme = useColorScheme();
  useSync(uid);

  return (
    // TanStack Query's cache (sync.ts) for every screen.
    <QueryClientProvider client={queryClient}>
      {/* keyboard-controller tracks the keyboard for every screen (the survey, step 10). */}
      <KeyboardProvider>
        <ThemeProvider value={scheme === 'dark' ? DarkTheme : DefaultTheme}>
          <Stack>
            <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
            <Stack.Screen name="entrances/[id]" options={{ title: 'Entrance' }} />
            <Stack.Screen name="survey/[id]" options={{ title: 'Survey' }} />
            <Stack.Screen name="conversations/[id]" options={{ title: 'Messages' }} />
            <Stack.Screen name="sync-status" options={{ title: 'Sync status' }} />
          </Stack>
          <StatusBar style="auto" />
        </ThemeProvider>
      </KeyboardProvider>
    </QueryClientProvider>
  );
}