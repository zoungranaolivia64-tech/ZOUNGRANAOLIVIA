import 'package:campusflow_models/campusflow_models.dart';

/// Contrat : les écrans ne connaissent que cette interface (jamais Dio).
abstract class TaskRepository {
  Future<List<Task>> fetchTasks();
  Future<Task> create(Task task);
  Future<Task> setDone(int id, bool done);
  Future<void> delete(int id);
  Future<List<Course>> fetchCourses();
  Future<User> fetchProfile();
}
