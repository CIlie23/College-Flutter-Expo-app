import 'dart:async';
import 'dart:io' show File;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth.dart';
import 'contract/contract.dart';
import 'db/database.dart';
import 'providers.dart';
import 'repositories.dart';

/// Server state: my pins as the cloud has them, live (one Firestore listener).
/// The banner watches it; SyncScope copies every new list into SQLite.
final myPinsProvider = StreamProvider<List<Entrance>>(
  (ref) => ref.watch(pinsRepositoryProvider).watchMine(ref.watch(uidProvider)),
);

/// The newest survey the cloud has from the signed-in worker.
final lastSentProvider = StreamProvider<Map<String, dynamic>?>(
  (ref) => ref
      .watch(surveysRepositoryProvider)
      .watchLastSent(ref.watch(uidProvider))
      .handleError((Object error) {
        debugPrint('$error');
        throw error;
      }),
);

final outboxProvider = StreamProvider(
  (ref) => ref.watch(databaseProvider).watchOutbox(),
);

var _pushing = false;

/// Push each unsent survey using its entrance id as the stable Firestore key.
Future<void> pushSurveys(WidgetRef ref) async {
  if (_pushing) return;
  _pushing = true;
  final db = ref.read(databaseProvider);
  final surveys = ref.read(surveysRepositoryProvider);
  final uid = ref.read(uidProvider);
  try {
    for (final entrance in await db.outbox()) {
      try {
        await surveys.push(surveyDoc(entrance, uid));
        await db.markSent(entrance.id, entrance.updatedAt, null);
      } on FirebaseException catch (error) {
        await db.markSent(entrance.id, entrance.updatedAt, error.code);
      }
    }
    if (const bool.fromEnvironment('UPLOAD_PHOTOS')) {
      await _pushPhotos(db, uid);
    }
  } finally {
    _pushing = false;
  }
}

/// Every photo not uploaded yet goes to photos/{uid}/{entranceId}/{photoId}.jpg.
Future<void> _pushPhotos(AppDatabase db, String uid) async {
  for (final photo in await db.photosToUpload()) {
    final file = FirebaseStorage.instance.ref(
      'photos/$uid/${photo.entranceId}/${photo.id}.jpg',
    );
    final meta = SettableMetadata(contentType: 'image/jpeg');
    try {
      if (photo.localUri.startsWith('data:')) {
        await file.putString(
          photo.localUri,
          format: PutStringFormat.dataUrl,
          metadata: meta,
        );
      } else {
        await file.putFile(File(photo.localUri), meta);
      }
      await db.markPhoto(photo.id, remoteUrl: await file.getDownloadURL());
    } on FirebaseException catch (error) {
      await db.markPhoto(photo.id, error: error.code);
    }
  }
}

/// Wraps the signed-in app: while it is on screen, the pull runs. Signing out
/// removes it, and Riverpod stops the listener nobody watches any more.
class SyncScope extends ConsumerStatefulWidget {
  const SyncScope({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<SyncScope> createState() => _SyncScopeState();
}

class _SyncScopeState extends ConsumerState<SyncScope> {
  late final AppLifecycleListener _lifecycle;
  late final StreamSubscription<List<ConnectivityResult>> _network;

  @override
  void initState() {
    super.initState();
    pushSurveys(ref);
    _lifecycle = AppLifecycleListener(onResume: () => pushSurveys(ref));
    _network = Connectivity().onConnectivityChanged.listen((links) {
      if (!links.contains(ConnectivityResult.none)) pushSurveys(ref);
    });
    // The pull: every snapshot of my pins goes to SQLite, the truth on the
    // phone. listenManual keeps the listener alive while this widget lives.
    ref.listenManual(myPinsProvider, (_, next) {
      final pins = next.value;
      if (pins != null) ref.read(databaseProvider).savePins(pins);
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _network.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
