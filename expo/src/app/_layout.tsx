import { DarkTheme, DefaultTheme, Stack, ThemeProvider } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { useEffect, useState } from 'react';
import { Text, useColorScheme, View } from 'react-native';
import { openDb } from '../db/db';

export default function RootLayout() {
  const scheme = useColorScheme();
  const [state, setState] = useState<'opening' | 'ready' | Error>('opening');
  useEffect(() => {
    openDb().then(
      () => setState('ready'),
      (e: Error) => setState(e),
    );
  }, []);

  if (state instanceof Error) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', padding: 24 }}>
        <Text>Could not open the database: {state.message}</Text>
      </View>
    );
  }
  if (state === 'opening') return null; // a few milliseconds

  return (
    <ThemeProvider value={scheme === 'dark' ? DarkTheme : DefaultTheme}>
      <Stack>
        <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
        <Stack.Screen name="entrances/[id]" options={{ title: 'Entrance' }} />
        <Stack.Screen name="survey/[id]" options={{ title: 'Survey' }} />
        <Stack.Screen name="conversations/[id]" options={{ title: 'Messages' }} />
      </Stack>
      <StatusBar style="auto" />
    </ThemeProvider>
  );
}