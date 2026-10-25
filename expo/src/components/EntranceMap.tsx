import {
  Camera,
  Map as MapLibreMap,
  Marker,
  type StyleSpecification,
  TransformRequestManager,
} from '@maplibre/maplibre-react-native';
import { router } from 'expo-router';
import { StyleSheet, Text, View } from 'react-native';
import { useEntrances } from '../store';
import { statusColor, statusLabel } from '../theme';

// OpenStreetMap's public tiles, weeks 2–4. Week 5 swaps this one constant for
// the course's own Bucharest tiles.
const TILES = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

// The OSM tile policy asks for a User-Agent that names the app. MapLibre can
// set request headers (react-native-maps' UrlTile could not).
TransformRequestManager.addHeader({
  id: 'osm-user-agent',
  name: 'User-Agent',
  value: 'FieldApp/1.0 (ro.rau.field_app; Mobile Devices Programming, RAU)',
  match: 'tile\\.openstreetmap\\.org',
});

// A MapLibre style (style spec v8): one raster source, one raster layer. No
// Google, no Apple, no key: the same map on every Android and iOS device.
const OSM_STYLE: StyleSpecification = {
  version: 8,
  sources: {
    osm: {
      type: 'raster',
      tiles: [TILES],
      tileSize: 256,
      maxzoom: 19,
      attribution: '© OpenStreetMap contributors',
    },
  },
  layers: [{ id: 'osm', type: 'raster', source: 'osm' }],
};

const BUCHAREST: [number, number] = [26.1025, 44.4355]; // [lng, lat]: MapLibre's order

export function EntranceMap() {
  const entrances = useEntrances();
  return (
    <>
      <MapLibreMap style={StyleSheet.absoluteFill} mapStyle={OSM_STYLE}>
        <Camera initialViewState={{ center: BUCHAREST, zoom: 13 }} />
        {entrances.map((e) => (
          <Marker
            key={e.id}
            id={e.id}
            lngLat={[e.correctedLng ?? e.lng, e.correctedLat ?? e.lat]}
            anchor="center"
            // The marker takes the press: a Pressable inside it gets no touches on Android.
            onPress={() => router.push(`/entrances/${e.id}`)}
          >
            <View
              accessible
              accessibilityRole="button"
              accessibilityLabel={`${e.street} ${e.number}, ${e.entranceName}, ${statusLabel[e.surveyStatus]}`}
              style={styles.hit}
            >
              <View style={[styles.pin, { backgroundColor: statusColor[e.surveyStatus] }]} />
            </View>
          </Marker>
        ))}
      </MapLibreMap>
      <Text style={styles.attribution}>© OpenStreetMap contributors</Text>
    </>
  );
}

const styles = StyleSheet.create({
  hit: { width: 44, height: 44, alignItems: 'center', justifyContent: 'center' },
  pin: { width: 24, height: 24, borderRadius: 12, borderWidth: 3, borderColor: '#ffffff' },
  attribution: {
    position: 'absolute',
    right: 4,
    bottom: 4,
    fontSize: 11,
    paddingHorizontal: 4,
    backgroundColor: 'rgba(255,255,255,0.8)',
    color: '#111827',
  },
});