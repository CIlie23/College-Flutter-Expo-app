import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The signed-in user, or null. Firebase keeps the session itself (Android:
/// the app's storage; web: the browser), so a restart finds it again.
final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

/// The signed-in worker's uid. Only read behind the gate in main.dart.
final uidProvider = Provider<String>(
  (ref) => ref.watch(authStateProvider).value!.uid,
);
