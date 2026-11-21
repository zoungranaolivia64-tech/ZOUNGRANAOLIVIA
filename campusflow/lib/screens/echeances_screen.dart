import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../core/theme.dart';
import '../providers.dart';
import 'task_detail_view.dart';

class EcheancesScreen extends ConsumerWidget {
  const EcheancesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Échéances')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Ajouter une tâche',
        onPressed: () => context.push('/taches/nouvelle'),
        child: const Icon(Icons.add),
      ),
      // LayoutBuilder : en dessous de 840 dp la liste seule, au-dessus liste + détail.
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= kTabletBreakpoint;
          if (!wide) return _ListePane(wide: false);
          final selected = ref.watch(selectionProvider);
          final tasks = ref.watch(tachesProvider).value ?? const <Task>[];
          final found = tasks.where((t) => t.id == selected);
          return Row(
            children: [
              const SizedBox(width: 380, child: _ListePane(wide: true)),
              const VerticalDivider(width: 1),
              Expanded(
                child: found.isEmpty
                    ? const Center(child: Text('Sélectionnez une tâche'))
                    : TaskDetailView(task: found.first),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ListePane extends ConsumerWidget {
  const _ListePane({required this.wide});

  final bool wide;

  static const _labels = {
    Filtre.aFaire: 'À faire',
    Filtre.faites: 'Faites',
    Filtre.enRetard: 'En retard',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupes = ref.watch(tachesParFiltreProvider);
    final filtre = ref.watch(filtreProvider);

    return groupes.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48),
              const SizedBox(height: 12),
              const Text('Impossible de charger les tâches.', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(tachesProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
      data: (map) {
        final liste = map[filtre]!;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Wrap(
                spacing: 8,
                children: [
                  for (final f in Filtre.values)
                    ChoiceChip(
                      label: Text('${_labels[f]} (${map[f]!.length})'),
                      selected: f == filtre,
                      onSelected: (_) => ref.read(filtreProvider.notifier).choisir(f),
                    ),
                ],
              ),
            ),
            Expanded(
              child: liste.isEmpty
                  ? const Center(child: Text('Aucune tâche ici.'))
                  : RefreshIndicator(
                      onRefresh: () async => ref.invalidate(tachesProvider),
                      child: ListView.builder(
                        itemCount: liste.length,
                        itemBuilder: (context, i) => _TaskTile(task: liste[i], wide: wide),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _TaskTile extends ConsumerWidget {
  const _TaskTile({required this.task, required this.wide});

  final Task task;
  final bool wide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final late = task.isOverdue();
    final scheme = Theme.of(context).colorScheme;
    final date = DateFormat('d MMM, HH:mm', 'fr').format(task.dueDate);

    return Dismissible(
      key: ValueKey('task-${task.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: scheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: scheme.onError),
      ),
      onDismissed: (_) => ref.read(tachesProvider.notifier).remove(task.id!), // DELETE
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(decoration: task.done ? TextDecoration.lineThrough : null),
        ),
        subtitle: Text(
          late ? 'En retard · $date' : date,
          style: TextStyle(color: late ? scheme.error : null),
        ),
        leading: Checkbox(
          value: task.done,
          onChanged: (_) => ref.read(tachesProvider.notifier).toggle(task), // PATCH
        ),
        onTap: () {
          if (wide) {
            ref.read(selectionProvider.notifier).choisir(task.id);
          } else {
            context.push('/taches/${task.id}');
          }
        },
      ),
    );
  }
}
