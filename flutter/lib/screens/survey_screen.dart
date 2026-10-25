import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class SurveyScreen extends ConsumerWidget {
  const SurveyScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entrance = ref.watch(entranceProvider(id)).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Survey')),
      body: entrance == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Survey ${entrance.entranceName}'),
            ),
    );
  }
}
