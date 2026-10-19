import { useColorScheme } from 'react-native';
import type { SurveyStatus } from './contract/contract';

const light = {
  background: '#ffffff',
  card: '#f3f4f6',
  text: '#111827',
  muted: '#4b5563',
  border: '#d1d5db',
  primary: '#c2410c',
  onPrimary: '#ffffff',
  error: '#b91c1c',
};

const dark: typeof light = {
  background: '#0b0f17',
  card: '#1f2937',
  text: '#f9fafb',
  muted: '#9ca3af',
  border: '#374151',
  primary: '#fb923c',
  onPrimary: '#111827',
  error: '#f87171',
};

export type Colors = typeof light;

/** The app follows the system: light or dark, read on every render. */
export function useColors(): Colors {
  return useColorScheme() === 'dark' ? dark : light;
}

export const statusLabel: Record<SurveyStatus, string> = {
  not_started: 'Not started',
  in_progress: 'In progress',
  submitted: 'Submitted',
  approved: 'Approved',
  needs_rework: 'Needs rework',
};

export const statusColor: Record<SurveyStatus, string> = {
  not_started: '#6b7280',
  in_progress: '#2563eb',
  submitted: '#16a34a',
  approved: '#15803d',
  needs_rework: '#dc2626',
};