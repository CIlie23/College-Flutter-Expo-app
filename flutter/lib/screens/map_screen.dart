import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../contract/contract.dart';
import '../providers.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entrances = ref.watch(entrancesProvider).value ?? const <Entrance>[];
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: ListView(
        children: [
          for (final entrance in entrances)
            ListTile(
              title: Text(entrance.entranceName),
              subtitle: Text('${entrance.lat}, ${entrance.lng}'),
            ),
        ],
      ),
    );
  }
}
