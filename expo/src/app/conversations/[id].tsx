import { useLocalSearchParams } from 'expo-router';
import { FlatList, StyleSheet, Text, View } from 'react-native';
import { ME } from '../../contract/fixtures';
import { messagesOf, nameOf } from '../../inbox';
import { useColors } from '../../theme';

export default function ConversationScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const colors = useColors();
  return (
    <FlatList
      style={{ backgroundColor: colors.background }}
      contentContainerStyle={styles.list}
      data={messagesOf(id)}
      keyExtractor={(m) => m.id}
      renderItem={({ item: m }) => {
        const mine = m.authorId === ME;
        return (
          <View
            style={[
              styles.bubble,
              mine
                ? { alignSelf: 'flex-end', backgroundColor: colors.primary }
                : { alignSelf: 'flex-start', backgroundColor: colors.card },
            ]}
          >
            {mine ? null : (
              <Text style={[styles.author, { color: colors.muted }]}>{nameOf(m.authorId)}</Text>
            )}
            <Text style={{ color: mine ? colors.onPrimary : colors.text }}>{m.text}</Text>
          </View>
        );
      }}
    />
  );
}

const styles = StyleSheet.create({
  list: { padding: 16, gap: 8 },
  bubble: { maxWidth: '80%', padding: 10, borderRadius: 14 },
  author: { fontSize: 12, marginBottom: 2 },
});