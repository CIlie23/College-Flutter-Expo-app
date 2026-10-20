import { type ReactNode, useEffect, useRef } from 'react';
import { Animated } from 'react-native';

// Exercise 3 — no shared-element transitions in Expo Go: the element flies in
// (fades and rises 16 px) when its screen mounts.
export function FlyIn({ children }: { children: ReactNode }) {
  const progress = useRef(new Animated.Value(0)).current;
  useEffect(() => {
    Animated.timing(progress, {
      toValue: 1,
      duration: 400,
      useNativeDriver: true,
    }).start();
  }, [progress]);
  const translateY = progress.interpolate({ inputRange: [0, 1], outputRange: [16, 0] });
  return (
    <Animated.View style={{ opacity: progress, transform: [{ translateY }] }}>
      {children}
    </Animated.View>
  );
}