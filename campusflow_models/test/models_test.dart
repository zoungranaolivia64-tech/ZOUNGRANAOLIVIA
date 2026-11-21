import 'package:campusflow_models/campusflow_models.dart';
import 'package:test/test.dart';

void main() {
  final base = Task(
    id: 1,
    title: 'Rendre le TP',
    courseId: 1,
    dueDate: DateTime(2026, 11, 22, 23, 59),
  );

  test('copyWith crée une copie modifiée sans toucher à l\'original', () {
    final done = base.copyWith(done: true);
    expect(done.done, isTrue);
    expect(base.done, isFalse);
    expect(done.title, base.title);
  });

  test('fromJson construit une Task valide', () {
    final task = Task.fromJson({
      'id': 7,
      'title': 'Exposé',
      'courseId': 2,
      'dueDate': '2026-12-01T10:00:00',
      'done': true,
    });
    expect(task.id, 7);
    expect(task.title, 'Exposé');
    expect(task.done, isTrue);
    expect(task.dueDate, DateTime(2026, 12, 1, 10));
  });

  test('fromJson lance une FormatException si le titre manque', () {
    expect(
      () => Task.fromJson({'courseId': 1, 'dueDate': '2026-12-01T10:00:00'}),
      throwsA(isA<FormatException>()),
    );
  });

  test('le dépôt simulé renvoie des tâches (Future.delayed)', () async {
    final repo = MockTaskRepository(delay: const Duration(milliseconds: 10));
    final tasks = await repo.fetchTasks();
    expect(tasks, isNotEmpty);
  });
}
