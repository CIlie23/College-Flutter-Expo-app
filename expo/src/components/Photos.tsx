import { useState } from 'react';
import { Image, Pressable, StyleSheet, Text, View } from 'react-native';
import { compassPoint } from '../location';
import { type ExifSummary, takePhoto, usePhotos, pickPhoto } from '../photos';
import { useColors } from '../theme';

export function Photos({ entranceId }: { entranceId: string }) {
  const colors = useColors();
  const list = usePhotos(entranceId);
  const [exif, setExif] = useState<ExifSummary | null>(null);
  const [busy, setBusy] = useState(false);
  const run = (action: () => Promise<ExifSummary | null>) => async () => {
    setBusy(true);
    try {
      const summary = await action();
      if (summary) setExif(summary);
    } finally {
      setBusy(false);
    }
  };
  return (
    <View style={[styles.card, { borderColor: colors.border }]}>
      <Text style={[styles.h2, { color: colors.text }]}>Photos ({list.length})</Text>
      <View style={styles.row}>
        <Pressable
          accessibilityRole="button"
          disabled={busy}
          onPress={run(() => takePhoto(entranceId))}
          style={[styles.button, { backgroundColor: colors.primary }]}
        >
          <Text style={{ color: colors.onPrimary, fontWeight: '700' }}>Take a photo</Text>
        </Pressable>

        <Pressable
          accessibilityRole="button"
          disabled={busy}
          onPress={run(() => pickPhoto(entranceId))}
          style={[styles.button, styles.outline, { borderColor: colors.primary }]}
        >
          <Text style={{ color: colors.primary, fontWeight: '700' }}>From the gallery</Text>
        </Pressable>
      </View>
      {exif ? (
        <Text style={{ color: colors.muted }}>
          Last file's EXIF: {exif.camera ?? 'no camera name'} · {exif.shotAt ?? 'no time'} · GPS in
          EXIF: {exif.gpsInExif ? 'yes' : 'no'}
        </Text>
      ) : null}
      {list.map((p) => (
        <View key={p.id} style={styles.photo}>
          <Image source={{ uri: p.localUri }} style={styles.thumb} accessibilityLabel="Entrance photo" />
          <View style={styles.meta}>
            <Text style={{ color: colors.text }}>{new Date(p.takenAt).toLocaleString()}</Text>
            <Text style={{ color: colors.muted }}>
              {p.lat === null || p.lng === null
                ? 'no position'
                : `${p.lat.toFixed(5)}, ${p.lng.toFixed(5)}`}
              {p.heading === null ? '' : ` · facing ${Math.round(p.heading)}° ${compassPoint(p.heading)}`}
            </Text>
            <Text style={{ color: colors.muted }} numberOfLines={1}>
              {p.fileName}
            </Text>
          </View>
        </View>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  outline: { borderWidth: 2 },
  card: { alignSelf: 'stretch', borderWidth: 1, borderRadius: 12, padding: 12, gap: 10 },
  h2: { fontSize: 18, fontWeight: '700' },
  row: { flexDirection: 'row', gap: 8 },
  button: { flex: 1, minHeight: 48, borderRadius: 12, alignItems: 'center', justifyContent: 'center' },
  photo: { flexDirection: 'row', gap: 10, alignItems: 'center' },
  thumb: { width: 72, height: 72, borderRadius: 8, backgroundColor: '#00000022' },
  meta: { flex: 1, gap: 2 },
});