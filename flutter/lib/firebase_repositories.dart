import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'contract/contract.dart';
import 'repositories.dart';

class FirebasePinsRepository implements PinsRepository {
  final _pins = FirebaseFirestore.instance.collection('pins');

  @override
  Stream<List<Entrance>> watchMine(String uid) => _pins
      // The query asks for exactly what the rules allow: my pins, and only mine.
      .where('assignedTo', isEqualTo: uid)
      .snapshots()
      .map(
        (snap) => [
          for (final d in snap.docs)
            Entrance.fromJson(d.data()..remove('assignedTo')),
        ],
      );

  @override
  Future<({int created, int refused})> seed(
    String uid,
    List<Entrance> pins,
  ) async {
    // A batch is all or nothing: if the rules refuse one pin, none is written.
    final batch = FirebaseFirestore.instance.batch();
    for (final p in pins) {
      batch.set(_pins.doc(p.id), {...p.toJson(), 'assignedTo': uid});
    }
    try {
      await batch.commit();
      return (created: pins.length, refused: 0);
    } on FirebaseException {
      return (created: 0, refused: pins.length);
    }
  }
}

class FirebaseSurveysRepository implements SurveysRepository {
  final _surveys = FirebaseFirestore.instance.collection('surveys');

  @override
  Future<void> push(Map<String, Object?> survey) =>
      // The document id is the survey's UUID: a second push overwrites it.
      _surveys.doc(survey['id']! as String).set(survey);

  @override
  Stream<CloudSurvey> watchOne(String id) => _surveys
      .doc(id)
      .snapshots(includeMetadataChanges: true)
      .map<CloudSurvey>(
        (snapshot) => !snapshot.exists
            ? (state: CloudState.none, updatedAt: null)
            : snapshot.metadata.hasPendingWrites
            ? (state: CloudState.pending, updatedAt: null)
            : (
                state: CloudState.sent,
                updatedAt: snapshot.data()?['updatedAt'] as String?,
              ),
      )
      .transform(
        StreamTransformer.fromHandlers(
          handleError:
              (
                Object error,
                StackTrace stackTrace,
                EventSink<CloudSurvey> sink,
              ) {
                sink.add((state: CloudState.denied, updatedAt: null));
              },
        ),
      );

  @override
  Stream<Map<String, dynamic>?> watchLastSent(String uid) => _surveys
      .where('surveyedBy', isEqualTo: uid)
      .orderBy('surveyedAt', descending: true)
      .limit(1)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.isEmpty ? null : snapshot.docs.first.data(),
      );
}
