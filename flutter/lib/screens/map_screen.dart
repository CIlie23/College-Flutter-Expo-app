import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../contract/contract.dart';
import '../providers.dart';
import '../session.dart';
import 'status_chip.dart';
import 'sync_bar.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entrances = ref.watch(entrancesProvider).value ?? const <Entrance>[];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        actions: [
          Text(
            FirebaseAuth.instance.currentUser?.email ?? '',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            child: const Text('Sign out'),
          ),
        ],
      ),
      const SyncBar(),
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
