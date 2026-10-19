import { DarkTheme, DefaultTheme, Stack, ThemeProvider } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { useColorScheme } from 'react-native';

export default function RootLayout() {
  const scheme = useColorScheme();
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