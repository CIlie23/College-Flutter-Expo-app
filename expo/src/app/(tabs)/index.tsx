import * as Haptics from 'expo-haptics';
import { Redirect, router } from 'expo-router';
import { useNetworkState } from 'expo-network';
import { useState } from 'react';
import { Platform, Pressable, StyleSheet, Text, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { EntranceMap } from '../../components/EntranceMap';
import { locate } from '../../location';
import { lastTab, useToken } from '../../session';
import { addMissedEntrance, useEntrances } from '../../store';
import { useColors } from '../../theme';

// Read once per launch: the tab the app was closed on (the web keeps its URL instead).
let reopen = Platform.OS === 'web' ? null : lastTab.get();

export default function MapScreen() {
  const insets = useSafeAreaInsets();
  const colors = useColors();
  const entrances = useEntrances();
  const done = entrances.filter((e) => e.surveyStatus !== 'not_started').length;
  const [busy, setBusy] = useState(false);
  const network = useNetworkState();
  const token = useToken();
  // isInternetReachable is null until the phone has checked; then true or false.
  const online = network.isConnected !== false && network.isInternetReachable !== false;

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
  if (reopen && reopen !== '/') {
    const to = reopen;
    reopen = null;
    return <Redirect href={to as '/route' | '/inbox'} />;
  }
  reopen = null;

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
        <View style={styles.chips}>
          <View style={[styles.chip, { backgroundColor: online ? '#16a34a' : '#6b7280' }]}>
            <Text style={styles.chipText}>
              {online ? `Online · ${network.type ?? '…'}` : 'Offline — saved on the phone'}
            </Text>
          </View>
          <Text style={{ color: colors.muted, fontSize: 12 }}>
            token {token ? `••••${token.slice(-4)}` : '…'}
          </Text>
        </View>
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
  chips: { flexDirection: 'row', alignItems: 'center', gap: 8, marginTop: 6 },
  chip: { paddingHorizontal: 10, paddingVertical: 3, borderRadius: 999 },
  chipText: { color: '#ffffff', fontSize: 12, fontWeight: '600' },
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