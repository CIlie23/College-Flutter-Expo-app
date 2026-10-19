import { router, useLocalSearchParams } from 'expo-router';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { StatusChip } from '../../components/StatusChip';
import { buildings } from '../../contract/fixtures';
import { useEntrance } from '../../store';
import { useColors } from '../../theme';

const show = (v: number | boolean | string | null) =>
  v === null ? '—' : typeof v === 'boolean' ? (v ? 'Yes' : 'No') : String(v);

export default function EntranceScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const entrance = useEntrance(id);
  const colors = useColors();
  if (!entrance) {
    return <Text style={{ color: colors.text, padding: 16 }}>No such entrance.</Text>;
  }
  const building = buildings.find((b) => b.id === entrance.buildingId);
  const rows: [string, number | boolean | string | null][] = [
    ['Pin confirmed', entrance.coordsConfirmed],
    ['Address checked', entrance.addressConfirmed],
    ['Stories', entrance.stories],
    ['Flats', entrance.flats],
    ['Elevators', entrance.elevators],
    ['Year built', entrance.yearBuilt],
    ['Shops on the ground floor', entrance.groundFloorCommercial],
    ['Comment', entrance.comment],
  ];
  return (
    <ScrollView
      style={{ backgroundColor: colors.background }}
      contentContainerStyle={styles.content}
    >
      <Text style={[styles.h1, { color: colors.text }]}>
        {entrance.street} {entrance.number}
      </Text>
      <Text style={{ color: colors.muted }}>
        {entrance.entranceName} · {building?.label}
      </Text>
      <StatusChip status={entrance.surveyStatus} />
      <Text style={{ color: colors.muted }}>
        Office pin: {entrance.lat.toFixed(5)}, {entrance.lng.toFixed(5)}
      </Text>
      {building?.comment ? (
        <Text style={{ color: colors.text }}>Office note: {building.comment}</Text>
      ) : null}
      <View style={[styles.table, { borderColor: colors.border }]}>
        {rows.map(([label, value]) => (
          <View key={label} style={styles.row}>
            <Text style={{ color: colors.muted }}>{label}</Text>
            <Text style={[styles.value, { color: colors.text }]}>{show(value)}</Text>
          </View>
        ))}
      </View>
      <Pressable
        accessibilityRole="button"
        onPress={() => router.push(`/survey/${entrance.id}`)}
        style={({ pressed }) => [
          styles.button,
          { backgroundColor: colors.primary, opacity: pressed ? 0.7 : 1 },
        ]}
      >
        <Text style={{ color: colors.onPrimary, fontWeight: '700' }}>Survey</Text>
      </Pressable>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  content: { padding: 16, gap: 12, alignItems: 'flex-start' },
  h1: { fontSize: 24, fontWeight: '700' },
  table: { alignSelf: 'stretch', borderWidth: 1, borderRadius: 12, padding: 12, gap: 8 },
  row: { flexDirection: 'row', justifyContent: 'space-between', gap: 12 },
  value: { flexShrink: 1, textAlign: 'right', fontWeight: '600' },
  button: {
    alignSelf: 'stretch',
    minHeight: 48,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
});