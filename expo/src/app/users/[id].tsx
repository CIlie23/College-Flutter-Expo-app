import { Stack, useLocalSearchParams } from 'expo-router';
import { StyleSheet, Text, View } from 'react-native';
import { users } from '../../contract/fixtures';
import { useColors } from '../../theme';

// Exercise 1 — a param route: /users/<id>
export default function UserScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const colors = useColors();
  const user = users.find((u) => u.id === id);
  return (
    <View style={[styles.screen, { backgroundColor: colors.background }]}>
      <Stack.Screen options={{ title: user?.name ?? 'Unknown' }} />
      <Text style={[styles.name, { color: colors.text }]}>
        {user?.name ?? 'No such person.'}
      </Text>
      <Text style={{ color: colors.muted }}>
        {user?.role === 'admin' ? 'Office (admin)' : 'Field worker'} · {user?.email}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, padding: 16, gap: 8 },
  name: { fontSize: 24, fontWeight: '700' },
});