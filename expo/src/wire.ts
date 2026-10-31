import { Entrance } from './contract/contract';

/**
 * Exercise 2 — what leaves the phone. Entrance.parse checks every rule of the
 * contract AND drops the keys the contract does not name (zod objects strip
 * unknown keys), so syncState, lastError and openedAt never travel.
 */
export const toWire = (row: Entrance): string => JSON.stringify(Entrance.parse(row));

/** What arrives: JSON text back into a checked entrance (throws on a bad one). */
export const fromWire = (json: string): Entrance => Entrance.parse(JSON.parse(json));