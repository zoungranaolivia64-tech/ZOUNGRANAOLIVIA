import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers.dart';
import 'task_detail_view.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key, required this.taskId});

  final int taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tachesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de la tâche'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/taches'),
        ),
        actions: [
          IconButton(
            tooltip: 'Supprimer',
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await ref.read(tachesProvider.notifier).remove(taskId);
              if (context.mounted) {
                context.canPop() ? context.pop() : context.go('/taches');
              }
            },
          ),
        ],
      ),
      body: tasks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (list) {
          final found = list.where((t) => t.id == taskId);
          if (found.isEmpty) return const Center(child: Text('Tâche introuvable'));
          return TaskDetailView(task: found.first);
        },
      ),
    );
  }
}
