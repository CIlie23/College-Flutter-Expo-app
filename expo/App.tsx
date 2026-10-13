import { StatusBar } from 'expo-status-bar';
import { Button, Platform, StyleSheet, Text, View, useWindowDimensions, useColorScheme } from 'react-native';
import { SafeAreaProvider, useSafeAreaInsets } from 'react-native-safe-area-context';
import { useState } from 'react';

type Building = {
  id: string;
  address: string;
  floors: number | null; // null = not surveyed yet
  elevators: number | null;
};

function describe(b: Building): string {
  const floors = b.floors ?? 'unknown';
  const elevators = b.elevators ?? 'unknown';
  return `${b.address}: ${floors} floors, elevators ${elevators}`;
}

const b: Building = { id: 'b-17', address: 'Str. Lipscani 12', floors: null, elevators: null};
let count = 3; // inferred: number
// count = 'three'; // error: Type 'string' is not assignable to type 'number'.
console.log(describe(b));
console.log(describe({ ...b, floors: 4}));
console.log(b.floors?.toFixed(1) ?? 'n/a');
console.log(`count is ${count}`);

function DeviceInfo() {
    const { width, height } = useWindowDimensions();
    const systemColorScheme = useColorScheme();
    const insets = useSafeAreaInsets();

    const orientation = width >= height ? 'landscape' : 'portrait';


    const [theme, setTheme] = useState<'light' | 'dark'>(systemColorScheme === 'dark' ? 'dark' : 'light');
    const isDark = theme === 'dark';
    const bgColor = isDark ? '#121212' : '#ffffff';
    const textColor = isDark ? '#ffffff' : '#000000';

    const toggleTheme = () => {
        setTheme((prevTheme) => (prevTheme === 'light' ? 'dark' : 'light'));
    };

    return (
        <View style={[styles.container, { backgroundColor: bgColor }]}>
          <Text style={[styles.title, { color: textColor }]}>CARAP SI ILIE</Text>
          <Text style={{ color: textColor }}>WASSUP FROM {Platform.OS}</Text>
          <Text style={{ color: textColor }}>{describe(b)}</Text>
          <Text style={{ color: textColor }}>{describe({ ...b, floors: 4})}</Text>

          <Text style={{ color: textColor }}>orientation: {orientation}</Text>
          <Text style={{ color: textColor }}>dark mode: {isDark ? 'yes' : 'no'}</Text>
          <Text style={{ color: textColor }}>
            safe area insets: top={insets.top}, bottom={insets.bottom}, left={insets.left}, right={insets.right}
          </Text>
          <Text style={{ color: textColor }}>
            why safe area matters: ignoring insets places fixed UI elements like a Save button under screen cutouts or the system gesture bar, making them unclickable.
          </Text>

          <Button
            title={`Change to ${ isDark ? 'Light' : 'Dark'} mode`}
            onPress={toggleTheme}
            color={isDark ? '#3b82f6' : '#1d4ed8'}
          />

          <StatusBar style={isDark ? 'light' : 'dark'} />
        </View>
    );
}

export default function App() {
  return (
    <SafeAreaProvider>
      <DeviceInfo />
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
    padding: 16,
  },
  title: { fontSize: 28, fontWeight: '700' },
});