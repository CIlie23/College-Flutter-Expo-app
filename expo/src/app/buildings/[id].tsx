import { router, useLocalSearchParams } from 'expo-router';
import { FlatList, Pressable, StyleSheet, Text, View } from 'react-native';
import { StatusChip } from '../../components/StatusChip';
import { buildings } from '../../contract/fixtures';
import { useEntrances } from '../../store';
import { useColors } from '../../theme';

export default function BuildingScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const colors = useColors();
  const all = useEntrances();
  const building = buildings.find((b) => b.id === id);
  if (!building) {
    return <Text style={{ color: colors.text, padding: 16 }}>No such building.</Text>;
  }
  const entrances = all.filter((e) => e.buildingId === building.id);
  return (
    <FlatList
      style={{ backgroundColor: colors.background }}
      contentContainerStyle={styles.list}
      data={entrances}
      keyExtractor={(e) => e.id}
      ListHeaderComponent={
        <View style={styles.head}>
          <Text accessibilityRole="header" style={[styles.h1, { color: colors.text }]}>
            {building.label}
          </Text>
          {building.comment ? (
            <Text style={{ color: colors.text }}>{building.comment}</Text>
          ) : null}
        </View>
      }
      renderItem={({ item: e }) => (
        <Pressable
          accessibilityRole="button"
          onPress={() => router.push(`/entrances/${e.id}`)}
          style={[styles.row, { borderColor: colors.border }]}
        >
          <View style={styles.middle}>
            <Text style={{ color: colors.text, fontSize: 16, fontWeight: '600' }}>
              {e.entranceName}
            </Text>
            <Text style={{ color: colors.muted }}>
              {e.street} {e.number}
            </Text>
          </View>
          <StatusChip status={e.surveyStatus} />
        </Pressable>
      )}
    />
  );
}

const styles = StyleSheet.create({
  list: { padding: 16, gap: 8 },
  head: { gap: 6, marginBottom: 8 },
  h1: { fontSize: 22, fontWeight: '700' },
  row: {
    minHeight: 56,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    padding: 12,
    borderWidth: 1,
    borderRadius: 12,
  },
  middle: { flex: 1 },
});