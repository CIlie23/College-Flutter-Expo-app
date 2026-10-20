import { useEffect, useRef } from 'react';
import { Animated } from 'react-native';

// Exercise 4 — an animated pin: say the end (selected → 1.5×), not the frames.
// React Native's built-in Animated; useNativeDriver runs it on the UI thread.
export function Pin({ color, selected }: { color: string; selected: boolean }) {
  const scale = useRef(new Animated.Value(1)).current;
  useEffect(() => {
    Animated.spring(scale, {
      toValue: selected ? 1.5 : 1,
      useNativeDriver: true,
    }).start();
  }, [selected, scale]);
  return (
    <Animated.View
      style={{
        width: 22,
        height: 22,
        borderRadius: 11,
        borderWidth: 3,
        borderColor: '#ffffff',
        backgroundColor: color,
        transform: [{ scale }],
      }}
    />
  );
}