import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../location.dart';

/// Where the phone is and which way it faces.
class HereCard extends ConsumerStatefulWidget {
  const HereCard({super.key});

  @override
  ConsumerState<HereCard> createState() => _HereCardState();
}

class _HereCardState extends ConsumerState<HereCard> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final fix = ref.watch(fixProvider);
    final heading = ref.watch(headingProvider).value; // watching starts the compass
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(fix != null
                ? 'You: ${fix.lat.toStringAsFixed(5)}, ${fix.lng.toStringAsFixed(5)} · ±${fix.accuracy.round()} m'
                : _busy
                ? 'Finding you…'
                : 'No position yet'),
            Text(heading == null
                ? (kIsWeb ? 'Facing: no compass on the web' : 'Facing: waiting for the compass')
                : 'Facing: ${heading.round()}° ${compassPoint(heading)}'),
            const SizedBox(height: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              onPressed: _busy
                  ? null
                  : () async {
                setState(() => _busy = true);
                try {
                  await locate(context, ref);
                } finally {
                  if (mounted) setState(() => _busy = false);
                }
              },
              child: const Text('Where am I?'),
            ),
          ],
        ),
      ),
    );
  }
}