import { useState } from 'react';
import { Image, Modal, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { compassPoint } from '../location';
import { type ExifSummary, markRetake, pickPhoto, takePhoto, usePhotos } from '../photos';
import { useColors } from '../theme';

export function Photos({ entranceId }: { entranceId: string }) {
  const colors = useColors();
  const list = usePhotos(entranceId);
  const [exif, setExif] = useState<ExifSummary | null>(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [openId, setOpenId] = useState<string | null>(null);

  // Newest first. The timestamps are ISO strings, so text order is time order.
  const sorted = [...list].sort((a, b) => b.takenAt.localeCompare(a.takenAt));
  // A photo is replaced when a newer photo points at it.
  const replacedIds = new Set(list.map((p) => p.replacesPhotoId).filter(Boolean));
  const open = sorted.find((p) => p.id === openId) ?? null;

  const run = (action: () => Promise<ExifSummary | null>) => async () => {
    setBusy(true);
    setError(null);
    try {
      const summary = await action();
      if (summary) setExif(summary);
    } catch (e) {
      setError(e instanceof Error ? e.message : String(e));
    } finally {
      setBusy(false);
    }
  };

  const debugRetake = (id: string, note: string) => async () => {
    setError(null);
    try {
      await markRetake(id, note);
    } catch (e) {
      setError(e instanceof Error ? e.message : String(e));
    }
  };

  const needsRetake = (p: (typeof list)[number]) =>
    p.reviewStatus === 'retake' && !replacedIds.has(p.id);

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
      {error ? <Text style={{ color: colors.error }}>{error}</Text> : null}
      {exif ? (
        <Text style={{ color: colors.muted }}>
          Last file's EXIF: {exif.camera ?? 'no camera name'} · {exif.shotAt ?? 'no time'} · GPS in
          EXIF: {exif.gpsInExif ? 'yes' : 'no'}
        </Text>
      ) : null}

      {sorted.length === 0 ? (
        <Text style={{ color: colors.muted }}>No photos of this entrance yet.</Text>
      ) : (
        <View style={styles.grid}>
          {sorted.map((p) => (
            <Pressable
              key={p.id}
              accessibilityRole="button"
              accessibilityLabel="Open photo"
              onPress={() => setOpenId(p.id)}
            >
              <Image source={{ uri: p.localUri }} style={styles.thumb} />
              {needsRetake(p) ? (
                <View style={[styles.badge, { backgroundColor: colors.error }]}>
                  <Text style={styles.badgeText}>Retake</Text>
                </View>
              ) : null}
            </Pressable>
          ))}
        </View>
      )}

      <Modal visible={open !== null} animationType="slide" onRequestClose={() => setOpenId(null)}>
        {open ? (
          <ScrollView
            style={{ backgroundColor: colors.background }}
            contentContainerStyle={styles.modal}
          >
            <Image source={{ uri: open.localUri }} style={styles.full} resizeMode="contain" />
            <Text style={{ color: colors.text }}>{new Date(open.takenAt).toLocaleString()}</Text>
            <Text style={{ color: colors.muted }}>
              {open.lat === null || open.lng === null
                ? 'no position'
                : `${open.lat.toFixed(5)}, ${open.lng.toFixed(5)}`}
              {open.heading === null
                ? ''
                : ` · facing ${Math.round(open.heading)}° ${compassPoint(open.heading)}`}
            </Text>
            <Text style={{ color: colors.text }}>Review: {open.reviewStatus}</Text>
            {open.reviewStatus === 'retake' ? (
              <Text style={{ color: colors.error }}>Note: {open.reviewNote}</Text>
            ) : null}
            {replacedIds.has(open.id) ? (
              <Text style={{ color: colors.muted }}>Replaced by a newer photo.</Text>
            ) : null}
            {error ? <Text style={{ color: colors.error }}>{error}</Text> : null}

            {needsRetake(open) ? (
              <Pressable
                accessibilityRole="button"
                disabled={busy}
                onPress={() => {
                  const oldId = open.id;
                  setOpenId(null); // close first: the camera should not open over a modal
                  run(() => takePhoto(entranceId, oldId))();
                }}
                style={[styles.button, { backgroundColor: colors.primary }]}
              >
                <Text style={{ color: colors.onPrimary, fontWeight: '700' }}>Retake</Text>
              </Pressable>
            ) : null}

            {__DEV__ && open.reviewStatus === 'pending' ? (
              <View style={styles.row}>
                <Pressable
                  onPress={debugRetake(open.id, 'too dark')}
                  style={[styles.button, styles.outline, { borderColor: colors.border }]}
                >
                  <Text style={{ color: colors.text }}>Debug: retake "too dark"</Text>
                </Pressable>
                <Pressable
                  onPress={debugRetake(open.id, '')}
                  style={[styles.button, styles.outline, { borderColor: colors.border }]}
                >
                  <Text style={{ color: colors.text }}>Debug: retake, empty note</Text>
                </Pressable>
              </View>
            ) : null}

            <Pressable
              accessibilityRole="button"
              onPress={() => setOpenId(null)}
              style={[styles.button, styles.outline, { borderColor: colors.border }]}
            >
              <Text style={{ color: colors.text }}>Close</Text>
            </Pressable>
          </ScrollView>
        ) : null}
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  outline: { borderWidth: 2 },
  card: { alignSelf: 'stretch', borderWidth: 1, borderRadius: 12, padding: 12, gap: 10 },
  h2: { fontSize: 18, fontWeight: '700' },
  row: { flexDirection: 'row', gap: 8 },
  button: { flex: 1, minHeight: 48, borderRadius: 12, alignItems: 'center', justifyContent: 'center' },
  grid: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  thumb: { width: 96, height: 96, borderRadius: 8, backgroundColor: '#00000022' },
  badge: { position: 'absolute', top: 4, left: 4, borderRadius: 6, paddingHorizontal: 6, paddingVertical: 2 },
  badgeText: { color: '#fff', fontSize: 12, fontWeight: '700' },
  modal: { padding: 16, gap: 12 },
  full: { width: '100%', height: 360 },
});