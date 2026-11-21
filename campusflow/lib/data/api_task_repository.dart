import 'package:campusflow_models/campusflow_models.dart';
import 'package:dio/dio.dart';

import 'task_repository.dart';

/// Implémentation qui appelle l'API json-server.
class ApiTaskRepository implements TaskRepository {
  ApiTaskRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Task>> fetchTasks() async {
    final r = await _dio.get<List<dynamic>>('/taches');
    return r.data!.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Task> create(Task task) async {
    final r = await _dio.post<Map<String, dynamic>>('/taches', data: task.toJson());
    return Task.fromJson(r.data!);
  }

  @override
  Future<Task> setDone(int id, bool done) async {
    final r = await _dio.patch<Map<String, dynamic>>('/taches/$id', data: {'done': done});
    return Task.fromJson(r.data!);
  }

  @override
  Future<void> delete(int id) async {
    await _dio.delete<void>('/taches/$id');
  }

  @override
  Future<List<Course>> fetchCourses() async {
    final r = await _dio.get<List<dynamic>>('/cours');
    return r.data!.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<User> fetchProfile() async {
    final r = await _dio.get<Map<String, dynamic>>('/utilisateurs/1');
    return User.fromJson(r.data!);
  }
}
