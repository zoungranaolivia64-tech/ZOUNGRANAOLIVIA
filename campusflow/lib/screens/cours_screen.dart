import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class CoursScreen extends ConsumerWidget {
  const CoursScreen({super.key});

  Color _couleur(String hex) {
    final v = int.tryParse(hex.replaceFirst('#', ''), radix: 16);
    return v == null ? Colors.grey : Color(0xFF000000 | v);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cours = ref.watch(coursProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Cours')),
      body: cours.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: FilledButton(
            onPressed: () => ref.invalidate(coursProvider),
            child: const Text('Réessayer'),
          ),
        ),
        data: (list) => ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) => ListTile(
            leading: CircleAvatar(backgroundColor: _couleur(list[i].color), radius: 8),
            title: Text(list[i].name),
            subtitle: Text(list[i].teacher),
          ),
        ),
      ),
    );
  }
}
