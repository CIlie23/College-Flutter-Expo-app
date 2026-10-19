import { Tabs } from 'expo-router';
import { type ColorValue, Text } from 'react-native';
import { totalUnread } from '../../inbox';
import { useColors } from '../../theme';

const icon = (glyph: string) =>
  function TabIcon({ color }: { color: ColorValue }) {
    return <Text style={{ color, fontSize: 20 }}>{glyph}</Text>;
  };

export default function TabsLayout() {
  const colors = useColors();
  return (
    <Tabs screenOptions={{ tabBarActiveTintColor: colors.primary }}>
      <Tabs.Screen
        name="index"
        options={{ title: 'Map', headerShown: false, tabBarIcon: icon('◉') }}
      />
      <Tabs.Screen
        name="route"
        options={{ title: 'My route', tabBarIcon: icon('☰') }}
      />
      <Tabs.Screen
        name="inbox"
        options={{
          title: 'Inbox',
          tabBarIcon: icon('✉'),
          tabBarBadge: totalUnread || undefined,
        }}
      />
    </Tabs>
  );
}