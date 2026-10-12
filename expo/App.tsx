import { StatusBar } from 'expo-status-bar';
import { Platform, StyleSheet, Text, View } from 'react-native';

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



export default function App() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>CARAP SI ILIE</Text>
      <Text>WASSUP FROM {Platform.OS}</Text>
      <Text>{describe(b)}</Text>
      <Text>{describe({ ...b, floors: 4})}</Text>
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
  },
  title: { fontSize: 28, fontWeight: '700' },
});