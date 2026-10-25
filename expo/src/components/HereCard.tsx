import { useState } from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { ensureCamera, ensureLocation } from '../permissions';
import { useColors } from '../theme';

/** Step 6: ask in context. Steps 7 and 8 turn these buttons into a fix and a photo. */
export function HereCard() {
  const colors = useColors();
  const [location, setLocation] = useState('not asked yet');
  const [camera, setCamera] = useState('not asked yet');
  const button = [styles.button, { borderColor: colors.primary }];
  return (
    <View style={[styles.card, { borderColor: colors.border }]}>
      <Text style={{ color: colors.text }}>Location: {location}</Text>
      <Text style={{ color: colors.text }}>Camera: {camera}</Text>
      <View style={styles.row}>
        <Pressable
          accessibilityRole="button"
          style={button}
          onPress={async () => setLocation((await ensureLocation()) ? 'allowed' : 'not allowed')}
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