import 'package:campusflow_models/campusflow_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/dio_client.dart';
import 'core/token_storage.dart';
import 'data/api_task_repository.dart';
import 'data/task_repository.dart';

// ───────────── Infrastructure ─────────────

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final dioProvider = Provider<Dio>((ref) {
  return createDio(
    storage: ref.watch(tokenStorageProvider),
    // Lu au moment de l'appel (pas à la création) : pas de dépendance circulaire.
    onUnauthorized: () => ref.read(authProvider.notifier).logout(),
  );
});

/// Les écrans passent par ce contrat ; les tests le remplacent par FakeTaskRepository.
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return ApiTaskRepository(ref.watch(dioProvider));
});

// ───────────── Authentification ─────────────

enum AuthStatus { unknown, loggedOut, loggedIn }

class AuthNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() {
    Future.microtask(_restore);
    return AuthStatus.unknown;
  }

  Future<void> _restore() async {
    final token = await ref.read(tokenStorageProvider).read();
    state = token == null ? AuthStatus.loggedOut : AuthStatus.loggedIn;
  }

  /// Lance une [DioException] si les identifiants sont refusés (401).
  Future<void> login(String email, String password) async {
    final response = await ref.read(dioProvider).post<Map<String, dynamic>>(
      '/login',
      data: {'email': email, 'password': password},
    );
    final token = response.data!['token'] as String;
    await ref.read(tokenStorageProvider).write(token);
    state = AuthStatus.loggedIn;
  }

  Future<void> logout() async {
    await ref.read(tokenStorageProvider).delete();
    state = AuthStatus.loggedOut;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthStatus>(AuthNotifier.new);

// ───────────── Tâches (AsyncNotifier) ─────────────

/// État immuable : on assigne toujours une NOUVELLE liste, on ne modifie jamais l'ancienne.
class TachesNotifier extends AsyncNotifier<List<Task>> {
  TaskRepository get _repo => ref.read(taskRepositoryProvider);

  @override
  Future<List<Task>> build() => _repo.fetchTasks();

  Future<void> add(Task task) async {
    final created = await _repo.create(task); // POST
    state = AsyncData([...state.value ?? const <Task>[], created]);
  }

  Future<void> toggle(Task task) async {
    final updated = await _repo.setDone(task.id!, !task.done); // PATCH
    state = AsyncData([
      for (final t in state.value ?? const <Task>[]) t.id == updated.id ? updated : t,
    ]);
  }

  Future<void> remove(int id) async {
    await _repo.delete(id); // DELETE
    state = AsyncData([
      for (final t in state.value ?? const <Task>[]) if (t.id != id) t,
    ]);
  }
}

final tachesProvider =
    AsyncNotifierProvider<TachesNotifier, List<Task>>(TachesNotifier.new);

// ───────────── Filtres (fournisseurs dérivés) ─────────────

enum Filtre { aFaire, faites, enRetard }

class FiltreNotifier extends Notifier<Filtre> {
  @override
  Filtre build() => Filtre.aFaire;
  void choisir(Filtre f) => state = f;
}

final filtreProvider = NotifierProvider<FiltreNotifier, Filtre>(FiltreNotifier.new);

/// Calcule les trois listes à partir de l'état partagé.
final tachesParFiltreProvider = Provider<AsyncValue<Map<Filtre, List<Task>>>>((ref) {
  return ref.watch(tachesProvider).whenData((tasks) {
    final now = DateTime.now();
    final tri = (List<Task> l) => (l..sort((a, b) => a.dueDate.compareTo(b.dueDate)));
    return {
      Filtre.aFaire: tri(tasks.where((t) => !t.done).toList()),
      Filtre.faites: tri(tasks.where((t) => t.done).toList()),
      Filtre.enRetard: tri(tasks.where((t) => t.isOverdue(now)).toList()),
    };
  });
});

/// Tâche sélectionnée dans la version tablette (liste + détail côte à côte).
class SelectionNotifier extends Notifier<int?> {
  @override
  int? build() => null;
  void choisir(int? id) => state = id;
}

final selectionProvider = NotifierProvider<SelectionNotifier, int?>(SelectionNotifier.new);

// ───────────── Cours et profil ─────────────

final coursProvider = FutureProvider<List<Course>>(
  (ref) => ref.watch(taskRepositoryProvider).fetchCourses(),
);

final profilProvider = FutureProvider<User>(
  (ref) => ref.watch(taskRepositoryProvider).fetchProfile(),
);
