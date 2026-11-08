import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth.dart';
import '../providers.dart';
import '../sync.dart';

/// The banner's sync line: what the cloud has, what waits to be sent.
class SyncBar extends ConsumerStatefulWidget {
  const SyncBar({super.key});

  @override
  ConsumerState<SyncBar> createState() => _SyncBarState();
}

class _SyncBarState extends ConsumerState<SyncBar> {
  String? _seeded;

  // Dev only: until the office side exists (week 7), the contract's fixtures
  // become my pins. kDebugMode is false in a release build: the button goes.
  Future<void> _seed() async {
    setState(() => _seeded = 'Seeding…');
    final r = await ref
        .read(pinsRepositoryProvider)
        .seed(ref.read(uidProvider), ref.read(fixturesProvider).entrances);
    setState(
      () => _seeded =
          '${r.created} pins are yours · ${r.refused} already someone else\'s',
    );
  }

  @override
  Widget build(BuildContext context) {
    final small = Theme.of(context).textTheme.bodySmall;
    final cloud = ref.watch(myPinsProvider).value;
    final box = ref.watch(outboxProvider).value;
    final last = ref.watch(lastSentProvider);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        Text(
          cloud == null
              ? 'cloud: connecting…'
              : 'cloud: ${cloud.length} pins, live',
          style: small,
        ),
        if (kDebugMode && cloud != null && cloud.isEmpty)
          TextButton(onPressed: _seed, child: const Text('Seed my pins')),
        if (_seeded != null) Text(_seeded!, style: small),
        if (box != null)
          Text('${box.pending} to send · ${box.failed} refused', style: small),
        TextButton(
          onPressed: () => pushSurveys(ref),
          child: const Text('Sync now'),
        ),
        if (box?.lastError != null)
          Text(
            'last refusal: ${box!.lastError}',
            style: small?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        Text(
          'last sent: ${switch (last) {
            AsyncError() => 'needs an index (see the log)',
            AsyncData(value: final survey?) => '${survey['street']} ${survey['number']}, '
                '${survey['entranceName']}, '
                '${DateTime.parse(survey['surveyedAt'] as String).toLocal().toString().substring(11, 19)}',
            AsyncData() => 'none',
            _ => '…',
          }}',
          style: small,
        ),
      ],
    );
  }
}
