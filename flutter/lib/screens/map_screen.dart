import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uuid/uuid.dart';

import '../contract/contract.dart';
import '../location.dart';
import '../providers.dart';
import '../session.dart';
import 'status_chip.dart';

// OpenStreetMap's public tiles, weeks 2–4. Week 5 swaps this one constant for
// the course's own Bucharest tiles.
const tiles = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const bucharest = LatLng(44.4355, 26.1025);

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entrances = ref.watch(entrancesProvider).value ?? const <Entrance>[];
    final links = ref.watch(connectivityProvider).value ?? const [ConnectivityResult.other];
    final online = !links.contains(ConnectivityResult.none);
    final token = ref.watch(tokenProvider).value;
    final recent = ref.watch(recentProvider); // exercise 5
    final names = {for (final e in entrances) e.id: e.entranceName};
    final done =
        entrances.where((e) => e.surveyStatus != SurveyStatus.not_started).length;
    return Stack(
      children: [
        FlutterMap(
          options: const MapOptions(initialCenter: bucharest, initialZoom: 13),
          children: [
            TileLayer(
              urlTemplate: tiles,
              // OSM's policy: a distinct User-Agent. flutter_map builds it
              // from this package name.
              userAgentPackageName: 'ro.rau.field_app',
            ),
            MarkerLayer(
              markers: [
                for (final e in entrances)
                  Marker(
                    point: LatLng(e.correctedLat ?? e.lat, e.correctedLng ?? e.lng),
                    width: 44,
                    height: 44,
                    child: Semantics(
                      button: true,
                      label: '${e.street} ${e.number}, ${e.entranceName}',
                      child: GestureDetector(
                        onTap: () => context.push('/entrances/${e.id}'),
                        child: Icon(Icons.location_on,
                            size: 40, color: statusColor[e.surveyStatus]),
                      ),
                    ),
                  ),
              ],
            ),
            const SimpleAttributionWidget(source: Text('OpenStreetMap contributors')),
          ],
        ),
        // No app bar on this tab: SafeArea keeps the banner clear of the notch.
        SafeArea(
          // Align, not Center: a Stack's child may be as big as the Stack,
          // and Center would stretch the card over the whole map.
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('${entrances.length} entrances · $done surveyed',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text('Recently opened: ${recent.isEmpty ? 'none' : recent.map((id) => names[id] ?? '?').join(', ')}',
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 6),
                    // Wrap, not Row: the contract has its own Row (the base of every entity).
                    Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                      Chip(
                        visualDensity: VisualDensity.compact,
                        backgroundColor: online ? const Color(0xFF16A34A) : const Color(0xFF6B7280),
                        label: Text(
                          online ? 'Online · ${links.first.name}' : 'Offline — saved on the phone',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(token == null ? 'token …' : 'token ••••${token.substring(token.length - 4)}',
                          style: Theme.of(context).textTheme.bodySmall),
                    ]),
                  ]),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 24,
          child: FloatingActionButton.extended(
            tooltip: 'Add a building that is not on the map, here',
            onPressed: () => _addMissed(context, ref),
            icon: const Icon(Icons.add_location_alt),
            label: const Text('Missed building'),
          ),
        ),
      ],
    );
  }

  /// The office's map is missing a building: pin it where you stand, then survey it.
  Future<void> _addMissed(BuildContext context, WidgetRef ref) async {
    final fix = await locate(context, ref);
    if (fix == null) return;
    final id = await ref.read(databaseProvider).addMissedEntrance(
          fix.lat, fix.lng, const Uuid().v4(), const Uuid().v4());
    await HapticFeedback.mediumImpact();
    if (context.mounted) context.push('/entrances/$id/survey');
  }
}
