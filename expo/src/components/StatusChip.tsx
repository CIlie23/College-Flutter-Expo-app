import { StyleSheet, Text, View } from 'react-native';
import type { SurveyStatus } from '../contract/contract';
import { statusColor, statusLabel } from '../theme';

export function StatusChip({ status }: { status: SurveyStatus }) {
  return (
    <View style={[styles.chip, { backgroundColor: statusColor[status] }]}>
      <Text style={styles.text}>{statusLabel[status]}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  chip: { paddingHorizontal: 10, paddingVertical: 4, borderRadius: 999 },
  text: { color: '#ffffff', fontSize: 13, fontWeight: '600' },
});