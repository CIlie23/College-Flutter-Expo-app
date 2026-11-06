import type { Entrance, EntranceSurvey, SurveyStatus } from './contract/contract';

// What the app needs from "the cloud", and nothing about how. Screens and the
// sync code use these interfaces; only firebaseRepositories.ts knows Firebase.
// Week 5 adds a Supabase implementation of the same two interfaces.

/** A survey as it travels: the surveyed fields, who, when, and which entrance. */
export type SurveyDoc = EntranceSurvey & {
  id: string; // the entrance's UUID: one survey per entrance, so a resend overwrites
  surveyStatus: SurveyStatus;
  surveyedBy: string;
  surveyedAt: string;
  updatedAt: string;
};

export interface PinsRepository {
  /** Calls onPins with all my pins now, and again after every change. Returns "stop". */
  watchMine(uid: string, onPins: (pins: Entrance[]) => void, onError: (e: Error) => void): () => void;
  /** Dev only: make these pins mine. Counts the ones that already belong to someone. */
  seed(uid: string, pins: Entrance[]): Promise<{ created: number; refused: number }>;
}

export interface SurveysRepository {
  /** Idempotent: sending the same survey twice leaves one document. */
  push(survey: SurveyDoc): Promise<void>;
}