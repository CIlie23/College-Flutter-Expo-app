import * as Haptics from 'expo-haptics';
import { router } from 'expo-router';
import { useState } from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { EntranceMap } from '../../components/EntranceMap';
import { locate } from '../../location';
import { addMissedEntrance, useEntrances } from '../../store';
import { useColors } from '../../theme';

export default function MapScreen() {
  const insets = useSafeAreaInsets();
  const colors = useColors();
  const entrances = useEntrances();
  const done = entrances.filter((e) => e.surveyStatus !== 'not_started').length;
  const [busy, setBusy] = useState(false);

  // The office's map is missing a building: pin it where you stand, then survey it.
  const addMissed = async () => {
    setBusy(true);
    try {
      const fix = await locate();
      if (!fix) return;
      const id = await addMissedEntrance(fix);
      await Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
      router.push(`/survey/${id}`);
    } finally {
      setBusy(false);
    }
  };
  return (
    <View style={[styles.screen, { backgroundColor: colors.background }]}>
      <EntranceMap />
      {/* No header on this tab: the banner keeps clear of the notch itself. */}
      <View
        style={[
          styles.banner,
          { top: insets.top + 8, backgroundColor: colors.card },
        ]}
      >
        <Text style={{ color: colors.text, fontWeight: '600' }}>
          {entrances.length} entrances · {done} surveyed
        </Text>
      </View>
      <Pressable
        accessibilityRole="button"
        accessibilityLabel="Add a building that is not on the map, here"
        disabled={busy}
        onPress={addMissed}
        style={[styles.fab, { backgroundColor: colors.primary, opacity: busy ? 0.6 : 1 }]}
      >
        <Text style={{ color: colors.onPrimary, fontWeight: '700' }}>
          {busy ? 'Finding you…' : '+ Missed building'}
        </Text>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1 },
  fab: {
    position: 'absolute',
    right: 16,
    bottom: 32,
    minHeight: 52,
    paddingHorizontal: 18,
    borderRadius: 26,
    justifyContent: 'center',
    elevation: 4,
  },
  banner: {
    position: 'absolute',
    left: 16,
    right: 16,
    padding: 12,
    borderRadius: 12,
    alignItems: 'center',
  },
});