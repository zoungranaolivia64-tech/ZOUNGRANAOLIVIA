import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../providers.dart';

class FormScreen extends ConsumerStatefulWidget {
  const FormScreen({super.key});

  @override
  ConsumerState<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends ConsumerState<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titre = TextEditingController();
  final _description = TextEditingController();
  int? _coursId;
  DateTime _echeance = DateTime.now().add(const Duration(days: 1));
  bool _envoi = false;

  @override
  void dispose() {
    _titre.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _choisirDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _echeance,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (d == null || !mounted) return;
    final h = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_echeance),
    );
    if (!mounted) return;
    setState(() {
      _echeance = DateTime(d.year, d.month, d.day, h?.hour ?? 23, h?.minute ?? 59);
    });
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _envoi = true);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    try {
      await ref.read(tachesProvider.notifier).add(Task(
            title: _titre.text.trim(),
            description: _description.text.trim(),
            courseId: _coursId!,
            dueDate: _echeance,
          ));
      messenger.showSnackBar(const SnackBar(content: Text('Tâche ajoutée')));
      if (router.canPop()) {
        router.pop();
      } else {
        router.go('/taches');
      }
    } catch (_) {
      messenger.showSnackBar(const SnackBar(content: Text('Échec de l\'enregistrement')));
      if (mounted) setState(() => _envoi = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cours = ref.watch(coursProvider);
    final date = DateFormat('d MMMM yyyy à HH:mm', 'fr').format(_echeance);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle tâche'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/taches'),
        ),
      ),
      // Défilant : le clavier ne bloque jamais le bouton Enregistrer.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titre,
                decoration: const InputDecoration(labelText: 'Titre'),
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Le titre est obligatoire' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(labelText: 'Description (facultatif)'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              cours.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('Impossible de charger les cours'),
                data: (list) => DropdownButtonFormField<int>(
                  value: _coursId,
                  decoration: const InputDecoration(labelText: 'Cours'),
                  items: [
                    for (final c in list) DropdownMenuItem(value: c.id, child: Text(c.name)),
                  ],
                  onChanged: (v) => setState(() => _coursId = v),
                  validator: (v) => v == null ? 'Choisissez un cours' : null,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _choisirDate,
                icon: const Icon(Icons.event),
                label: Text(date),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _envoi ? null : _enregistrer,
                child: Text(_envoi ? 'Enregistrement…' : 'Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
