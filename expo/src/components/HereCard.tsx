import { useState } from 'react';
import { Platform, Pressable, StyleSheet, Text, View } from 'react-native';
import { compassPoint, locate, useHeading } from '../location';
import { ensureCamera } from '../permissions';
import { useField } from '../store';
import { useColors } from '../theme';

/** Where the phone is and which way it faces. Step 8 moves the camera to the photos. */
export function HereCard() {
  const colors = useColors();
  const fix = useField((s) => s.fix);
  const heading = useField((s) => s.heading);
  const [busy, setBusy] = useState(false);
  const [camera, setCamera] = useState('not asked yet');
  useHeading(fix !== null); // a fix means the location permission is granted
  const button = [styles.button, { borderColor: colors.primary }];
  return (
    <View style={[styles.card, { borderColor: colors.border }]}>
      <Text style={{ color: colors.text }}>
        {fix
          ? `You: ${fix.lat.toFixed(5)}, ${fix.lng.toFixed(5)} · ±${Math.round(fix.accuracy ?? 0)} m`
          : busy
            ? 'Finding you…'
            : 'No position yet'}
      </Text>
      <Text style={{ color: colors.text }}>
        {heading === null
          ? Platform.OS === 'web'
            ? 'Facing: no compass on the web'
            : 'Facing: waiting for the compass'
          : `Facing: ${Math.round(heading)}° ${compassPoint(heading)}`}
      </Text>
      <Text style={{ color: colors.text }}>Camera: {camera}</Text>
      <View style={styles.row}>
        <Pressable
          accessibilityRole="button"
          style={button}
          disabled={busy}
          onPress={async () => {
            setBusy(true);
            try {
              await locate();
            } finally {
              setBusy(false);
            }
          }}
        >
          <Text style={{ color: colors.primary, fontWeight: '700' }}>Where am I?</Text>
        </Pressable>
        <Pressable
          accessibilityRole="button"
          style={button}
          onPress={async () => setCamera((await ensureCamera()) ? 'allowed' : 'not allowed')}
        >
          <Text style={{ color: colors.primary, fontWeight: '700' }}>Camera</Text>
        </Pressable>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  card: { alignSelf: 'stretch', borderWidth: 1, borderRadius: 12, padding: 12, gap: 8 },
  row: { flexDirection: 'row', gap: 8 },
  button: {
    flex: 1,
    minHeight: 48,
    borderWidth: 2,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
});