import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'contract/contract.dart';
import 'auth.dart';
import 'db/database.dart';
import 'firebase_options.dart';
import 'providers.dart';
import 'store.dart';
import 'sync.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Before anything that talks to Firebase: your project's options, per platform.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (const bool.fromEnvironment('USE_EMULATORS')) {
    const host = String.fromEnvironment(
      'EMULATOR_HOST',
      defaultValue: '10.0.2.2',
    );
    final h = kIsWeb ? 'localhost' : host;
    await FirebaseAuth.instance.useAuthEmulator(h, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(h, 8080);
    await FirebaseStorage.instance.useStorageEmulator(h, 9199);
  }
  final fixtures = await Fixtures.load();
  final database = AppDatabase();
  await database.seedIfEmpty(fixtures.buildings);
  runApp(
    ProviderScope(
      overrides: [
        fixturesProvider.overrideWithValue(fixtures),
        databaseProvider.overrideWithValue(database),
      ],
      child: const FieldApp(),
    ),
  );
}

const _seed = Color(0xFFC2410C);
final _light = ThemeData(colorSchemeSeed: _seed, brightness: Brightness.light);
final _dark = ThemeData(colorSchemeSeed: _seed, brightness: Brightness.dark);

/// The auth-state gate: no user, no app. Signing in or out rebuilds this.
class FieldApp extends ConsumerWidget {
  const FieldApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Field app',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    ),
    home: const HomeScreen(),
  );
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    if (user.value == null) {
      return MaterialApp(
        title: 'Field app',
        theme: _light,
        darkTheme: _dark,
        home: user.isLoading
            ? const Scaffold(body: Center(child: CircularProgressIndicator()))
            : const SignInScreen(),
      );
    }
    return SyncScope(
      child: MaterialApp.router(
        title: 'Field app',
        routerConfig: _router,
        theme: _light,
        darkTheme: _dark,
        themeMode: ThemeMode.system, // follow the phone's setting
      ),
    );
  }
}
