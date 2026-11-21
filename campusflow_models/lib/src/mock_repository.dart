import 'dart:convert';

import 'task.dart';

/// Dépôt simulé : renvoie des tâches après une attente produite par
/// [Future.delayed], pour pratiquer async / await / try-catch sans réseau.
class MockTaskRepository {
  MockTaskRepository({this.delay = const Duration(milliseconds: 300)});

  final Duration delay;

  static const _rawJson = '''
[
  {"id": 1, "title": "Rendre le TP de Programmation Mobile", "courseId": 1,
   "dueDate": "2026-11-22T23:59:00", "description": "Dépôt GitHub", "done": false},
  {"id": 2, "title": "Réviser Entrepôt de données", "courseId": 2,
   "dueDate": "2026-11-28T08:00:00", "done": false}
]
''';

  Future<List<Task>> fetchTasks() async {
    await Future<void>.delayed(delay);
    final list = jsonDecode(_rawJson) as List<dynamic>;
    return list
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  /// Simule une panne réseau : lance toujours une exception.
  Future<List<Task>> fetchTasksFailing() async {
    await Future<void>.delayed(delay);
    throw Exception('Connexion impossible');
  }
}
