import { collection, doc, onSnapshot, query, setDoc, where } from 'firebase/firestore';
import type { Entrance } from './contract/contract';
import { firestore } from './firebase';
import type { PinsRepository, SurveyDoc, SurveysRepository } from './repositories';

export const firebasePins: PinsRepository = {
  watchMine(uid, onPins, onError) {
    // The query asks for exactly what the rules allow: my pins, and only mine.
    const mine = query(collection(firestore, 'pins'), where('assignedTo', '==', uid));
    return onSnapshot(
      mine,
      (snap) =>
        onPins(
          snap.docs.map((d) => {
            const { assignedTo: _, ...entrance } = d.data();
            return entrance as Entrance;
          }),
        ),
      onError,
    );
  },

  async seed(uid, pins) {
    // One write per pin: a pin someone else already has is refused by the
    // rules (it would be an update), and the others still go through.
    const results = await Promise.allSettled(
      pins.map((p) => setDoc(doc(firestore, 'pins', p.id), { ...p, assignedTo: uid })),
    );
    const created = results.filter((r) => r.status === 'fulfilled').length;
    return { created, refused: pins.length - created };
  },
};

export const firebaseSurveys: SurveysRepository = {
  async push(survey: SurveyDoc) {
    // The document id is the survey's UUID: a second push of the same survey
    // overwrites the same document instead of making a copy.
    await setDoc(doc(firestore, 'surveys', survey.id), survey);
  },
};