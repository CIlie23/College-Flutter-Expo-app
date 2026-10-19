import { router } from 'expo-router';
import { StyleSheet, Text } from 'react-native';
import MapView, { Marker, UrlTile } from 'react-native-maps';
import { useEntrances } from '../store';
import { statusColor, statusLabel } from '../theme';

// OpenStreetMap's public tiles, weeks 2–4. Week 5 swaps this one constant for
// the course's own Bucharest tiles.
const TILES = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const BUCHAREST = {
  latitude: 44.4355,
  longitude: 26.1025,
  latitudeDelta: 0.06,
  longitudeDelta: 0.06,
};

export function EntranceMap() {
  const entrances = useEntrances();
  return (
    <>
      <MapView
        style={StyleSheet.absoluteFill}
        initialRegion={BUCHAREST}
      >
        {/* Our tiles over the platform's base map (Google on Android, Apple
            on iOS, where shouldReplaceMapContent hides Apple's). */}
        <UrlTile urlTemplate={TILES} maximumZ={19} shouldReplaceMapContent />
        {entrances.map((e) => (
          <Marker
            key={e.id}
            coordinate={{
              latitude: e.correctedLat ?? e.lat,
              longitude: e.correctedLng ?? e.lng,
            }}
            title={`${e.street} ${e.number}, ${e.entranceName}`}
            description={statusLabel[e.surveyStatus]}
            pinColor={statusColor[e.surveyStatus]}
            onCalloutPress={() => router.push(`/entrances/${e.id}`)}
          />
        ))}
      </MapView>
      <Text style={styles.attribution}>© OpenStreetMap contributors</Text>
    </>
  );
}

const styles = StyleSheet.create({
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