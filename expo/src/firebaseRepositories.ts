import type { Entrance } from './contract/contract';
import { firestore } from './firebase';
import { collection, doc, limit, onSnapshot, orderBy, query, setDoc, where, writeBatch } from 'firebase/firestore';
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
    // Exercise 3: one batched write instead of 20 separate ones. A batch is
    // all or nothing: if the rules refuse one pin, none is written.
    const batch = writeBatch(firestore);
    for (const p of pins) batch.set(doc(firestore, 'pins', p.id), { ...p, assignedTo: uid });
    try {
      await batch.commit();
      return { created: pins.length, refused: 0 };
    } catch (error) {
      console.warn('seed pins batch failed', error);
      return { created: 0, refused: pins.length };
    }
  },
};

export const firebaseSurveys: SurveysRepository = {
  async push(survey: SurveyDoc) {
    // The document id is the survey's UUID: a second push of the same survey
    // overwrites the same document instead of making a copy.
    await setDoc(doc(firestore, 'surveys', survey.id), survey);
  },

  watchLastSent(uid, onChange, onError) {
    // where on one field + orderBy on another: Firestore needs a composite index.
    const last = query(
      collection(firestore, 'surveys'),
      where('surveyedBy', '==', uid),
      orderBy('surveyedAt', 'desc'),
      limit(1),
    );
    return onSnapshot(last, (snap) => onChange((snap.docs[0]?.data() as SurveyDoc) ?? null), onError);
  },


  watchOne(id, onChange) {
    return onSnapshot(
      doc(firestore, 'surveys', id),
      // Exercise 4: also call back when only the metadata changes, i.e. when the
      // server confirms a write this phone made (hasPendingWrites true → false).
      { includeMetadataChanges: true },
      (snap) => {
        if (!snap.exists()) onChange({ state: 'none' });
        else if (snap.metadata.hasPendingWrites) onChange({ state: 'pending' });
        else onChange({ state: 'sent', updatedAt: snap.data().updatedAt });
      },
      () => onChange({ state: 'denied' }), // permission-denied: the rules said no
    );
  },
};