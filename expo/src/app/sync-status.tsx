/**
 * Retry policy. After a failed send that waiting could fix (no signal, cloud busy) the app waits
 * 10 s, then doubles the wait each time (20 s, 40 s … capped at 5 min) and gives up after 6
 * automatic tries; refusals that waiting cannot fix (permission-denied, a wrong answer) are never
 * retried automatically. It is not a loop without a wait because every try comes at least 10 s
 * after the last and the number of tries is bounded; the count resets only when the network
 * returns, the app comes to the foreground, or the worker presses Retry.
 */
import { useNetworkState } from 'expo-network';
import { useState } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { auth } from '../firebase';
import { useOutboxRows } from '../store';
import { retryNow } from '../sync';
import { friendlyError, useSyncTimes } from '../syncStatus';
import { useColors } from '../theme';

const when = (iso: string | null) => (iso ? new Date(iso).toLocaleString() : 'never');

export default function SyncStatusScreen() {
  const colors = useColors();
  const uid = auth.currentUser?.uid ?? '';
  const { rows, ready } = useOutboxRows();
  const times = useSyncTimes();
  const net = useNetworkState();
  const [busy, setBusy] = useState(false);

  const retry = async (only?: string) => {
    setBusy(true);
    try {
      await retryNow(uid, only);
    } finally {
      setBusy(false);
    }
  };

  const failed = rows.filter((r) => r.entrance.syncState === 'failed').length;
  const online = net.isConnected ? 'online' : net.isConnected === false ? 'offline' : 'checking…';

  return (
    <ScrollView style={{ backgroundColor: colors.background }} contentContainerStyle={styles.content}>
      {failed > 0 ? (
        <Pressable
          accessibilityRole="button"
          disabled={busy}
          onPress={() => retry()}
          style={[styles.button, { backgroundColor: colors.primary, opacity: busy ? 0.6 : 1 }]}
        >
          <Text style={{ color: colors.onPrimary, fontWeight: '700' }}>
            {busy ? 'Retrying…' : `Retry all (${failed})`}
          </Text>
        </Pressable>
      ) : null}

      {ready && rows.length === 0 ? (
        <Text style={{ color: colors.muted }}>Nothing waiting: every survey you sent has reached the office.</Text>
      ) : null}

      {rows.map(({ entrance: e, building }) => {
        const err = e.syncState === 'failed' ? friendlyError(e.lastError) : null;
        return (
          <View key={e.id} style={[styles.card, { borderColor: colors.border }]}>
            <Text style={[styles.title, { color: colors.text }]}>
              {building ?? 'Unknown building'} · {e.street} {e.number}, {e.entranceName}
            </Text>
            <Text style={{ color: colors.muted }}>Submitted {when(e.surveyedAt)}</Text>
            <Text style={{ color: err ? colors.error : colors.text, fontWeight: '600' }}>
              {e.syncState === 'failed' ? 'failed' : 'pending'}
            </Text>
            {err ? (
              <>
                <Text style={{ color: colors.error }}>{err.what}</Text>
                <Text style={{ color: colors.text }}>{err.todo}</Text>
                <Pressable
                  accessibilityRole="button"
                  disabled={busy}
                  onPress={() => retry(e.id)}
                  style={[styles.button, styles.outline, { borderColor: colors.primary, opacity: busy ? 0.6 : 1 }]}
                >
                  <Text style={{ color: colors.primary, fontWeight: '700' }}>Retry</Text>
                </Pressable>
              </>
            ) : (
              <Text style={{ color: colors.muted }}>Waiting for signal. It is sent by itself when the phone is online.</Text>
            )}
          </View>
        );
      })}

      <View style={[styles.card, { borderColor: colors.border }]}>
        <Text style={{ color: colors.text }}>Device: {online}</Text>
        <Text style={{ color: colors.muted }}>Last pull (office pins): {when(times.pull)}</Text>
        <Text style={{ color: colors.muted }}>Last push (your surveys): {when(times.push)}</Text>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  content: { padding: 16, gap: 12 },
  card: { borderWidth: 1, borderRadius: 12, padding: 12, gap: 6 },
  title: { fontSize: 16, fontWeight: '700' },
  button: { minHeight: 48, borderRadius: 12, alignItems: 'center', justifyContent: 'center' },
  outline: { borderWidth: 2, marginTop: 4 },
});