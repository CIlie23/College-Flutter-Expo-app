import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers.dart';
import 'here_card.dart';
import 'photos_card.dart';
import 'status_chip.dart';
import 'visit_lines.dart';

String show(Object? v) => v == null ? '—' : v is bool ? (v ? 'Yes' : 'No') : '$v';

class EntranceScreen extends ConsumerWidget {
  const EntranceScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final found = ref.watch(entranceProvider(id));
    if (found.isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final e = found.value;
    if (e == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('No such entrance.')));
    }
    // From SQLite, not the fixtures: a building made on the phone is there too.
    final building = ref.watch(buildingProvider(e.buildingId)).value;
    final rows = {
      'Pin confirmed': e.coordsConfirmed,
      'Address checked': e.addressConfirmed,
      'Stories': e.stories,
      'Flats': e.flats,
      'Elevators': e.elevators,
      'Year built': e.yearBuilt,
      'Shops on the ground floor': e.groundFloorCommercial,
      'Comment': e.comment,
    };
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Entrance')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('${e.street} ${e.number}', style: text.headlineSmall),
          Text(e.entranceName),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => context.push('/buildings/${e.buildingId}'),
              child: Text('${building?.label ?? 'Building'} · every entrance ›'),
            ),
          ),
          const SizedBox(height: 8),
          Align(alignment: Alignment.centerLeft, child: StatusChip(status: e.surveyStatus)),
          const SizedBox(height: 8),
          Text('Office pin: ${e.lat.toStringAsFixed(5)}, ${e.lng.toStringAsFixed(5)}'),
          if (building?.comment != null) Text('Office note: ${building!.comment}'),
          const SizedBox(height: 8),
          Card(
            child: Column(children: [
              for (final MapEntry(:key, :value) in rows.entries)
                ListTile(dense: true, title: Text(key), trailing: Text(show(value))),
            ]),
          ),
          const SizedBox(height: 8),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            onPressed: () => context.push('/entrances/${e.id}/survey'),
            child: const Text('Survey'),
          ),
          const SizedBox(height: 8),
          const HereCard(),
          VisitLines(entrance: e),
          PhotosCard(entranceId: e.id),
        ],
      ),
    );
  }
}
