import { router } from 'expo-router';
import { useState } from 'react';
import { FlatList, Pressable, StyleSheet, Text, View } from 'react-native';
import { StatusChip } from '../../components/StatusChip';
import { ME, routes } from '../../contract/fixtures';
import { filterStops, type StopFilter } from '../../routeFilter';
import { useEntrances } from '../../store';
import { useColors } from '../../theme';

const myRoute = routes.find((r) => r.workerId === ME);

const CHOICES: { value: StopFilter; label: string }[] = [
  { value: 'all', label: 'All' },
  { value: 'todo', label: 'To do' },
  { value: 'done', label: 'Done' },
  { value: 'skipped', label: 'Skipped' },
];

const EMPTY: Record<Exclude<StopFilter, 'all'>, string> = {
  todo: 'No stops left to do on this route.',
  done: 'No done stops on this route.',
  skipped: 'No skipped stops on this route.',
};

export default function RouteScreen() {
  const entrances = useEntrances();
  const colors = useColors();
  const [filter, setFilter] = useState<StopFilter>('all');
  if (!myRoute) return null;
  const stops = filterStops(myRoute.stops, filter);
  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      <Text style={[styles.header, { color: colors.text }]}>
        {myRoute.name} · {myRoute.date}
      </Text>
      <View style={styles.filters}>
        {CHOICES.map((c) => {
          const selected = c.value === filter;
          return (
            <Pressable
              key={c.value}
              accessibilityRole="button"
              accessibilityState={{ selected }}
              onPress={() => setFilter(c.value)}
              style={[
                styles.choice,
                {
                  borderColor: selected ? colors.primary : colors.border,
                  backgroundColor: selected ? colors.primary : 'transparent',
                },
              ]}
            >
              <Text
                style={{
                  color: selected ? colors.onPrimary : colors.text,
                  fontWeight: selected ? '700' : '400',
                }}
              >
                {c.label}
              </Text>
            </Pressable>
          );
        })}
      </View>
      <FlatList
        contentContainerStyle={styles.list}
        data={stops}
        keyExtractor={(s) => s.id}
        ListEmptyComponent={
          <Text style={{ color: colors.muted, padding: 8 }}>
            {filter === 'all' ? 'No stops on this route.' : EMPTY[filter]}
          </Text>
        }
        renderItem={({ item: stop }) => {
          const e = entrances.find((x) => x.id === stop.entranceId);
          if (!e) return null;
          return (
            <Pressable
              accessibilityRole="button"
              onPress={() => router.push(`/entrances/${e.id}`)}
              style={[styles.row, { borderColor: colors.border }]}
            >
              <Text style={[styles.order, { color: colors.muted }]}>{stop.order}</Text>
              <View style={styles.middle}>
                <Text style={{ color: colors.text, fontSize: 16 }}>
                  {e.street} {e.number}
                </Text>
                <Text style={{ color: colors.muted }}>{e.entranceName}</Text>
              </View>
              <StatusChip status={e.surveyStatus} />
            </Pressable>
          );
        }}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  header: { fontSize: 18, fontWeight: '700', padding: 16, paddingBottom: 8 },
  filters: { flexDirection: 'row', gap: 8, paddingHorizontal: 16, paddingBottom: 8 },
  choice: {
    minHeight: 44,
    paddingHorizontal: 14,
    borderWidth: 1,
    borderRadius: 999,
    alignItems: 'center',
    justifyContent: 'center',
  },
  list: { padding: 16, paddingTop: 8, gap: 8 },
  row: {
    minHeight: 56,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    padding: 12,
    borderWidth: 1,
    borderRadius: 12,
  },
  order: { width: 24, fontSize: 18, fontWeight: '700', textAlign: 'center' },
  middle: { flex: 1 },
});