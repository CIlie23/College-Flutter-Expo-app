import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'contract/contract.dart';
import 'db/database.dart';
import 'providers.dart';
import 'store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final fixtures = await Fixtures.load();
  final database = AppDatabase();
  await database.seedIfEmpty(fixtures.buildings, fixtures.entrances);
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

class FieldApp extends StatelessWidget {
  const FieldApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Field app',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
        home: const HomeScreen(),
      );
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entrances = ref.watch(entrancesProvider).value ?? const <Entrance>[];
    return Scaffold(
      appBar: AppBar(title: const Text('Field app')),
      body: ListView(
        children: [
          for (final entrance in entrances)
            ListTile(
              title: Text(entrance.entranceName),
              subtitle: Text('${entrance.street} ${entrance.number}'),
            ),
        ],
      ),
    );
  }
}
