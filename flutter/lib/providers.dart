import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'contract/contract.dart';
import 'db/database.dart';
import 'store.dart';

// Riverpod replaces week 2's StoreScope: every widget that needs something
// asks for its provider with ref.watch(…) and rebuilds when it changes.

/// The fixtures (routes, conversations, users) — still read-only files.
/// Given its value in main() with overrideWithValue.
final fixturesProvider = Provider<Fixtures>((ref) => throw UnimplementedError());

/// The open database, also given in main().
final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError());

/// Who is "signed in" until week 4.
final meProvider = Provider<String>((ref) => ref.watch(fixturesProvider).me);

// The data lives in SQLite; drift's watch() streams become StreamProviders.
final entrancesProvider = StreamProvider<List<Entrance>>(
  (ref) => ref.watch(databaseProvider).watchEntrances(),
);

final entranceProvider = StreamProvider.family<Entrance?, String>(
  (ref, id) => ref.watch(databaseProvider).watchEntrance(id),
);

final buildingProvider = StreamProvider.family<Building?, String>(
  (ref, id) => ref.watch(databaseProvider).watchBuilding(id),
);

final photosProvider = StreamProvider.family<List<PhotoRow>, String>(
  (ref, entranceId) => ref.watch(databaseProvider).watchPhotos(entranceId),
);

final openedAtProvider = StreamProvider.family<String?, String>(
  (ref, id) => ref.watch(databaseProvider).watchOpenedAt(id),
);

/// Exercise 5: the last five entrances opened, newest first (client state).
class RecentNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => const [];

  // A NEW list every time. state.add(id) would change the old list in place:
  // Riverpod compares the old and new state, sees the same list, and nobody
  // rebuilds (and a const list throws).
  void open(String id) => state = [id, ...state.where((x) => x != id)].take(5).toList();
}

final recentProvider = NotifierProvider<RecentNotifier, List<String>>(RecentNotifier.new);
