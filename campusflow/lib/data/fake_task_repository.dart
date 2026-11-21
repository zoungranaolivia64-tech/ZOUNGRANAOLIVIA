import 'package:campusflow_models/campusflow_models.dart';

import 'task_repository.dart';

/// Implémentation en mémoire, utilisée dans les tests.
class FakeTaskRepository implements TaskRepository {
  FakeTaskRepository({List<Task>? tasks, this.delay = const Duration(milliseconds: 20)})
      : _tasks = List.of(tasks ?? _seed);

  final Duration delay;
  final List<Task> _tasks;
  int _nextId = 100;

  static final _seed = [
    Task(
      id: 1,
      title: 'Rendre le TP de Programmation Mobile',
      courseId: 1,
      dueDate: DateTime(2030, 1, 1),
    ),
    Task(
      id: 2,
      title: 'Exposé terminé',
      courseId: 2,
      dueDate: DateTime(2030, 1, 2),
      done: true,
    ),
  ];

  @override
  Future<List<Task>> fetchTasks() async {
    await Future<void>.delayed(delay);
    return List.unmodifiable(_tasks);
  }

  @override
  Future<Task> create(Task task) async {
    await Future<void>.delayed(delay);
    final created = task.copyWith(id: _nextId++);
    _tasks.add(created);
    return created;
  }

  @override
  Future<Task> setDone(int id, bool done) async {
    await Future<void>.delayed(delay);
    final i = _tasks.indexWhere((t) => t.id == id);
    _tasks[i] = _tasks[i].copyWith(done: done);
    return _tasks[i];
  }

  @override
  Future<void> delete(int id) async {
    await Future<void>.delayed(delay);
    _tasks.removeWhere((t) => t.id == id);
  }

  @override
  Future<List<Course>> fetchCourses() async {
    await Future<void>.delayed(delay);
    return const [
      Course(id: 1, name: 'Programmation Mobile', teacher: 'M. COMPAORE'),
      Course(id: 2, name: 'Entrepôt de données', teacher: 'Dr. KABRE', color: '#B45309'),
    ];
  }

  @override
  Future<User> fetchProfile() async {
    await Future<void>.delayed(delay);
    return const User(
      id: 1,
      name: 'Awa Sawadogo',
      email: 'etudiant@campusflow.bf',
      filiere: 'Master 1 MSI',
    );
  }
}
