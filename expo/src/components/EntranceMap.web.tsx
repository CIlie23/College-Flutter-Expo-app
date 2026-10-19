import { router } from 'expo-router';
import { FlatList, Pressable, StyleSheet, Text } from 'react-native';
import { useEntrances } from '../store';
import { useColors } from '../theme';
import { StatusChip } from './StatusChip';

// react-native-maps has no web implementation. Metro picks this file instead
// of EntranceMap.tsx when it bundles for the web: the same pins, as a list.
export function EntranceMap() {
  const entrances = useEntrances();
  const colors = useColors();
  return (
    <FlatList
      data={entrances}
      keyExtractor={(e) => e.id}
      contentContainerStyle={styles.list}
      ListHeaderComponent={
        <Text style={[styles.note, { color: colors.muted }]}>
          The map is native only — on the web, the pins are a list.
        </Text>
      }
      renderItem={({ item: e }) => (
        <Pressable
          accessibilityRole="button"
          onPress={() => router.push(`/entrances/${e.id}`)}
          style={[styles.row, { borderColor: colors.border }]}
        >
          <Text style={[styles.title, { color: colors.text }]}>
            {e.street} {e.number}, {e.entranceName}
          </Text>
          <StatusChip status={e.surveyStatus} />
        </Pressable>
      )}
    />
  );
}

const styles = StyleSheet.create({
  list: { padding: 16, paddingTop: 72, gap: 8 },
  note: { marginBottom: 8 },
  row: {
    minHeight: 48,
    padding: 12,
    borderWidth: 1,
    borderRadius: 12,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 8,
  },
  title: { flexShrink: 1, fontSize: 16 },
});