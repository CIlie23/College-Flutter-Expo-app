import { router } from 'expo-router';
import { FlatList, Pressable, StyleSheet, Text, View } from 'react-native';
import { ME } from '../../contract/fixtures';
import { isUnread, messagesOf, myConversations, nameOf } from '../../inbox';
import { useColors } from '../../theme';

export default function InboxScreen() {
  const colors = useColors();
  return (
    <FlatList
      style={{ backgroundColor: colors.background }}
      contentContainerStyle={styles.list}
      data={myConversations}
      keyExtractor={(c) => c.id}
      renderItem={({ item: c }) => {
        const msgs = messagesOf(c.id);
        const last = msgs.at(-1);
        const unread = msgs.filter(isUnread).length;
        const title =
          c.kind === 'broadcast'
            ? 'Everyone'
            : nameOf(c.participantIds.find((p) => p !== ME) ?? '');
        return (
          <Pressable
            accessibilityRole="button"
            accessibilityLabel={`${title}, ${unread} unread`}
            onPress={() => router.push(`/conversations/${c.id}`)}
            style={[styles.row, { borderColor: colors.border }]}
          >
            <View style={styles.middle}>
              <Text style={[styles.title, { color: colors.text }]}>{title}</Text>
              <Text numberOfLines={1} style={{ color: colors.muted }}>
                {last?.text}
              </Text>
            </View>
            {unread > 0 ? (
              <View style={[styles.badge, { backgroundColor: colors.primary }]}>
                <Text style={{ color: colors.onPrimary, fontWeight: '700' }}>{unread}</Text>
              </View>
            ) : null}
          </Pressable>
        );
      }}
    />
  );
}

const styles = StyleSheet.create({
  list: { padding: 16, gap: 8 },
  row: {
    minHeight: 64,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    padding: 12,
    borderWidth: 1,
    borderRadius: 12,
  },
  middle: { flex: 1 },
  title: { fontSize: 16, fontWeight: '600' },
  badge: {
    minWidth: 28,
    height: 28,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 8,
  },
});