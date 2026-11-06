import { useState } from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { pins } from '../cloud';
import { entrances as fixtureEntrances } from '../contract/fixtures';
import { auth } from '../firebase';
import { useOutbox } from '../store';
import { useColors } from '../theme';
import { myPinsKey, pushSurveys } from '../sync';
import { skipToken, useQuery } from '@tanstack/react-query';
import type { Entrance } from '../contract/contract';

/** The banner's sync line: what the cloud has, what waits to be sent. */
export function SyncBar() {
  const colors = useColors();
  const uid = auth.currentUser?.uid ?? '';
  const [seeded, setSeeded] = useState<string | null>(null);
  // No queryFn: the listener fills this cache entry (setQueryData in sync.ts).
  const box = useOutbox();
  const cloud = useQuery<Entrance[]>({ queryKey: myPinsKey(uid), queryFn: skipToken });

  // Dev only: until the office side exists (week 7), the contract's fixtures
  // become my pins. __DEV__ is false in a release build: the button disappears.
  const seed = async () => {
    setSeeded('Seeding…');
    const { created, refused } = await pins.seed(uid, fixtureEntrances);
    setSeeded(`${created} pins are yours · ${refused} already someone else's`);
  };

  return (
    <View style={styles.row}>
      <Text style={{ color: colors.muted, fontSize: 12 }}>
        {cloud.data ? `cloud: ${cloud.data.length} pins, live` : 'cloud: connecting…'}
      </Text>
      {__DEV__ && cloud.data?.length === 0 && (
        <Pressable accessibilityRole="button" onPress={seed}>
          <Text style={[styles.link, { color: colors.primary }]}>Seed my pins</Text>
        </Pressable>
      )}
      {seeded && <Text style={{ color: colors.muted, fontSize: 12 }}>{seeded}</Text>}
      <Text style={{ color: colors.muted, fontSize: 12 }}>
        {box.pending} to send · {box.failed} refused
      </Text>
      <Pressable accessibilityRole="button" onPress={() => pushSurveys(uid)}>
        <Text style={[styles.link, { color: colors.primary }]}>Sync now</Text>
      </Pressable>
      {box.lastError && <Text style={styles.error}>last refusal: {box.lastError}</Text>}
    </View>
  );
}

const styles = StyleSheet.create({
  row: { flexDirection: 'row', flexWrap: 'wrap', alignItems: 'center', gap: 8, marginTop: 6 },
  link: { fontSize: 12, fontWeight: '600' },
  error: { color: '#dc2626', fontSize: 12 },
});