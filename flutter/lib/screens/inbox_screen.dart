import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../contract/contract.dart';
import '../providers.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = ref.watch(fixturesProvider);
    final mine = f.conversations.where((c) => c.participantIds.contains(f.me)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Inbox')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: mine.length,
        itemBuilder: (context, i) {
          final c = mine[i];
          final msgs = f.messages.where((m) => m.conversationId == c.id).toList()
            ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
          final unread =
              msgs.where((m) => m.authorId != f.me && !m.readAt.containsKey(f.me)).length;
          final title = c.kind == ConversationKind.broadcast
              ? 'Everyone'
              : f.users.firstWhere((u) => u.id != f.me && c.participantIds.contains(u.id)).name;
          return Card(
            child: ListTile(
              title: Text(title),
              subtitle: Text(msgs.last.text, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: unread > 0 ? Badge(label: Text('$unread')) : null,
              onTap: () => context.go('/inbox/conversations/${c.id}'),
            ),
          );
        },
      ),
    );
  }
}

class ConversationScreen extends ConsumerWidget {
  const ConversationScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = ref.watch(fixturesProvider);
    final scheme = Theme.of(context).colorScheme;
    final msgs = f.messages.where((m) => m.conversationId == id).toList()
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: msgs.length,
        itemBuilder: (context, i) {
          final m = msgs[i];
          final mine = m.authorId == f.me;
          return Align(
            alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300),
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: mine ? scheme.primaryContainer : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!mine)
                    Text(f.users.firstWhere((u) => u.id == m.authorId).name,
                        style: Theme.of(context).textTheme.labelSmall),
                  Text(m.text),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
