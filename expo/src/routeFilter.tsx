import type { RouteStop, StopStatus } from './contract/contract';

export type StopFilter = StopStatus | 'all';

/** stops + a status (or "all") in, a list sorted by `order` out. */
export function filterStops(stops: RouteStop[], filter: StopFilter): RouteStop[] {
  return stops
    .filter((s) => filter === 'all' || s.status === filter)
    .sort((a, b) => a.order - b.order);
}