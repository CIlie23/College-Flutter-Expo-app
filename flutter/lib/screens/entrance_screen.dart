import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../repositories.dart';

class EntranceScreen extends ConsumerWidget {
  const EntranceScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entrance = ref.watch(entranceProvider(id)).value;
    return Scaffold(
      appBar: AppBar(title: Text(entrance?.entranceName ?? 'Entrance')),
      body: entrance == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('${entrance.street} ${entrance.number}'),
                Text('Status: ${entrance.surveyStatus.name}'),
                Text(
                  'In the cloud: '
                  '${_cloudText(ref.watch(cloudSurveyProvider(entrance.id)).value)}',
                ),
              ],
            ),
    );
  }
}

String _cloudText(CloudSurvey? cloud) => switch (cloud?.state) {
  null => 'asking…',
  CloudState.none => 'not sent yet',
  CloudState.denied => 'refused by the rules',
  CloudState.pending => 'written on this phone, waiting for the server',
  CloudState.sent =>
    cloud?.updatedAt == null
        ? 'sent'
        : 'sent, ${DateTime.parse(cloud!.updatedAt!).toLocal().toString().substring(0, 19)}',
};
