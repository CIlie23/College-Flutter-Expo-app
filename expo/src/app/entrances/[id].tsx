import { router, useLocalSearchParams } from 'expo-router';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { FlyIn } from '../../components/FlyIn';
import { StatusChip } from '../../components/StatusChip';
import { ME, routes } from '../../contract/fixtures';
import { useBuilding, useEntrance, markOpened, useField} from '../../store';
import { useColors } from '../../theme';
import { HereCard } from '../../components/HereCard';
import { Photos } from '../../components/Photos';
import { useEffect } from 'react';
import type { Entrance } from '../../contract/contract';
import { fromWire, toWire } from '../../wire';

const show = (v: number | boolean | string | null) =>
  v === null ? '—' : typeof v === 'boolean' ? (v ? 'Yes' : 'No') : String(v);

export default function EntranceScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const entrance = useEntrance(id);
  // From SQLite, not the fixtures: a building made on the phone is there too.
  const building = useBuilding(entrance?.buildingId ?? '');
    // Exercises 1 and 5: remember the visit, in SQLite and in the store.
  useEffect(() => {
    markOpened(id);
    useField.getState().openRecent(id);
  }, [id]);
  const colors = useColors();
  if (entrance === undefined) return null; // SQLite has not answered yet
  if (!entrance) {
    return <Text style={{ color: colors.text, padding: 16 }}>No such entrance.</Text>;
  }
  const stops = routes.find((r) => r.workerId === ME)?.stops ?? [];
  const here = stops.find((st) => st.entranceId === entrance.id);
  const next = stops.find((st) => here && st.order === here.order + 1)?.entranceId;
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
        <View style={{ flexDirection: 'row', flexWrap: 'wrap', alignItems: 'center' }}>
          <Text style={{ color: colors.muted }}>{entrance.entranceName} · </Text>
          {building ? (
            <Pressable
              accessibilityRole="link"
              accessibilityHint="Opens the building screen"
              onPress={() => router.push(`/buildings/${building.id}`)}
              style={{ minHeight: 44, justifyContent: 'center' }}
            >
              <Text style={{ color: colors.primary, textDecorationLine: 'underline' }}>
                {building.label}
              </Text>
            </Pressable>
          ) : null}
        </View>
      </Text>
      {/* Exercise 3 — no shared elements in Expo Go: the chip flies in instead */}
      <FlyIn>
        <StatusChip status={entrance.surveyStatus} />
      </FlyIn>
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
      <HereCard />
      <Text style={{ color: colors.muted }}>
        Opened on this phone: {entrance.openedAt ? new Date(entrance.openedAt).toLocaleString() : 'never'}
        <WireJson entrance={entrance} color={colors.muted} />
      </Text>
      <Photos entranceId={entrance.id} />

      {next ? (
        // Exercise 5 — push adds a screen (Back returns here); replace swaps
        // this one out (Back skips it).
        <View style={styles.nextRow}>
          <Pressable
            accessibilityRole="button"
            onPress={() => router.push(`/entrances/${next}`)}
            style={[styles.next, { borderColor: colors.border }]}
          >
            <Text style={{ color: colors.text }}>Next stop (push)</Text>
          </Pressable>
          <Pressable
            accessibilityRole="button"
            onPress={() => router.replace(`/entrances/${next}`)}
            style={[styles.next, { borderColor: colors.border }]}
          >
            <Text style={{ color: colors.text }}>Next stop (replace)</Text>
          </Pressable>
        </View>
      ) : null}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  content: { padding: 16, gap: 12, alignItems: 'flex-start' },
  h1: { fontSize: 24, fontWeight: '700' },
  table: { alignSelf: 'stretch', borderWidth: 1, borderRadius: 12, padding: 12, gap: 8 },
  row: { flexDirection: 'row', justifyContent: 'space-between', gap: 12 },
  value: { flexShrink: 1, textAlign: 'right', fontWeight: '600' },
  nextRow: { alignSelf: 'stretch', flexDirection: 'row', gap: 8 },
  next: {
    flex: 1,
    minHeight: 48,
    borderWidth: 1,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  button: {
    alignSelf: 'stretch',
    minHeight: 48,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
});

// … at the end of the file:
/** Exercise 2: the entrance as it would travel, and the proof that it comes back the same. */
function WireJson({ entrance, color }: { entrance: Entrance; color: string }) {
  const json = toWire(entrance);
  const same = toWire(fromWire(json)) === json;
  return (
    <Text style={{ color, fontFamily: 'monospace', fontSize: 11 }}>
      {same ? 'Round trip: same JSON ✓' : 'Round trip: DIFFERENT ✗'} · {json.length} characters, {Object.keys(JSON.parse(json)).length} keys
    </Text>
  );
}