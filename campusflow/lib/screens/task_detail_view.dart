import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers.dart';

/// Contenu du détail d'une tâche (réutilisé par l'écran Détail et par le volet tablette).
class TaskDetailView extends ConsumerWidget {
  const TaskDetailView({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final date = DateFormat('EEEE d MMMM yyyy à HH:mm', 'fr').format(task.dueDate);
    final cours = ref.watch(coursProvider).value ?? const <Course>[];
    final matching = cours.where((c) => c.id == task.courseId);
    final courseName = matching.isEmpty ? 'Cours #${task.courseId}' : matching.first.name;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(courseName, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.schedule, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(date, style: theme.textTheme.bodyMedium)),
                  ]),
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(task.description, style: theme.textTheme.bodyLarge),
                  ],
                  const SizedBox(height: 12),
                  Chip(
                    avatar: Icon(task.done ? Icons.check_circle : Icons.radio_button_unchecked, size: 18),
                    label: Text(task.done ? 'Fait' : 'À faire'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            // ref.read dans un gestionnaire d'action (règle du cours).
            onPressed: () => ref.read(tachesProvider.notifier).toggle(task),
            child: Text(task.done ? 'Marquer comme à faire' : 'Marquer comme fait'),
          ),
        ],
      ),
    );
  }
}
