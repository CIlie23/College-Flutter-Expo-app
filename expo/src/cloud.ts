import { firebasePins, firebaseSurveys } from './firebaseRepositories';
import type { PinsRepository, SurveysRepository } from './repositories';

// The one place that chooses the implementation. Week 5 changes these two lines.
export const pins: PinsRepository = firebasePins;
export const surveys: SurveysRepository = firebaseSurveys;