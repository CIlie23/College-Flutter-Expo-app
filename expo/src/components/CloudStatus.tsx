import { useEffect, useState } from 'react';
import { Text } from 'react-native';
import { surveys } from '../cloud';
import type { CloudSurvey } from '../repositories';
import { useColors } from '../theme';

/** Exercise 1: what the cloud holds for this entrance's survey, live. */
export function CloudStatus({ id }: { id: string }) {
  const colors = useColors();
  const [cloud, setCloud] = useState<CloudSurvey | null>(null);
  useEffect(() => surveys.watchOne(id, setCloud), [id]);

  const text =
    cloud === null
      ? 'asking…'
      : cloud.state === 'none'
        ? 'not sent yet'
        : cloud.state === 'denied'
          ? 'refused by the rules'
            : cloud.state === 'pending'
            ? 'written on this phone, waiting for the server'
          : `sent, ${new Date(cloud.updatedAt).toLocaleString()}`;
  return <Text style={{ color: colors.muted }}>In the cloud: {text}</Text>;
}