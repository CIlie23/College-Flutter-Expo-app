import { StyleSheet, Text, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { EntranceMap } from '../../components/EntranceMap';
import { useEntrances } from '../../store';
import { useColors } from '../../theme';

export default function MapScreen() {
  const insets = useSafeAreaInsets();
  const colors = useColors();
  const entrances = useEntrances();
  const done = entrances.filter((e) => e.surveyStatus !== 'not_started').length;
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
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1 },
  banner: {
    position: 'absolute',
    left: 16,
    right: 16,
    padding: 12,
    borderRadius: 12,
    alignItems: 'center',
  },
});