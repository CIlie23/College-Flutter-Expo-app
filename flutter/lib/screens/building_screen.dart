import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../contract/contract.dart';
import '../providers.dart';

class BuildingScreen extends ConsumerWidget {
  const BuildingScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final building = ref.watch(buildingProvider(id)).value;
    final entrances = ref.watch(entrancesProvider).value ?? const <Entrance>[];
    return Scaffold(
      appBar: AppBar(title: Text(building?.label ?? 'Building')),
      body: ListView(
        children: [
          for (final entrance in entrances.where((e) => e.buildingId == id))
            ListTile(title: Text(entrance.entranceName)),
        ],
      ),
    );
  }
}
