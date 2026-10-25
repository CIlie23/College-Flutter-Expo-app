import { Tabs, usePathname } from 'expo-router';
import { useEffect } from 'react';
import { type ColorValue, Text } from 'react-native';
import { totalUnread } from '../../inbox';
import { lastTab } from '../../session';
import { useColors } from '../../theme';

const TAB_PATHS = ['/', '/route', '/inbox'];

const icon = (glyph: string) =>
  function TabIcon({ color }: { color: ColorValue }) {
    return <Text style={{ color, fontSize: 20 }}>{glyph}</Text>;
  };

export default function TabsLayout() {
  const colors = useColors();
  const pathname = usePathname();

  // Remember the tab; the Map screen reopens it at the next launch.
  useEffect(() => {
    if (TAB_PATHS.includes(pathname)) lastTab.set(pathname);
  }, [pathname]);

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