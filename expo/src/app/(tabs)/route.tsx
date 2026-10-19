import { router } from 'expo-router';
import { FlatList, Pressable, StyleSheet, Text, View } from 'react-native';
import { StatusChip } from '../../components/StatusChip';
import { ME, routes } from '../../contract/fixtures';
import { useEntrances } from '../../store';
import { useColors } from '../../theme';

const myRoute = routes.find((r) => r.workerId === ME);

export default function RouteScreen() {
  const entrances = useEntrances();
  const colors = useColors();
  if (!myRoute) return null;
  const stops = [...myRoute.stops].sort((a, b) => a.order - b.order);
  return (
    <FlatList
      style={{ backgroundColor: colors.background }}
      contentContainerStyle={styles.list}
      data={stops}
      keyExtractor={(s) => s.id}
      ListHeaderComponent={
        <Text style={[styles.header, { color: colors.text }]}>
          {myRoute.name} · {myRoute.date}
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
  );
}

const styles = StyleSheet.create({
  list: { padding: 16, gap: 8 },
  header: { fontSize: 18, fontWeight: '700', marginBottom: 8 },
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