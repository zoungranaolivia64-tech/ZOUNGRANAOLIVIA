import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers.dart';
import 'screens/cours_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/echeances_screen.dart';
import 'screens/form_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profil_screen.dart';
import 'screens/shell_scaffold.dart';

/// Prévient GoRouter qu'il doit réévaluer `redirect` quand l'authentification change.
class _AuthRefresh extends ChangeNotifier {
  void ping() => notifyListeners();
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefresh();
  ref.listen<AuthStatus>(authProvider, (_, __) => refresh.ping());
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/taches',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final loc = state.matchedLocation;
      switch (auth) {
        case AuthStatus.unknown:
          return loc == '/chargement' ? null : '/chargement';
        case AuthStatus.loggedOut:
          return loc == '/login' ? null : '/login'; // 401 ou pas de jeton
        case AuthStatus.loggedIn:
          return (loc == '/login' || loc == '/chargement') ? '/taches' : null;
      }
    },
    routes: [
      GoRoute(path: '/chargement', builder: (_, __) => const ChargementScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) =>
            ShellScaffold(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(path: '/taches', builder: (_, __) => const EcheancesScreen()),
          // « nouvelle » doit être déclarée AVANT « :id », sinon « nouvelle » serait lu comme un id.
          GoRoute(path: '/taches/nouvelle', builder: (_, __) => const FormScreen()),
          GoRoute(
            path: '/taches/:id',
            builder: (_, state) =>
                DetailScreen(taskId: int.tryParse(state.pathParameters['id'] ?? '') ?? -1),
          ),
          GoRoute(path: '/cours', builder: (_, __) => const CoursScreen()),
          GoRoute(path: '/profil', builder: (_, __) => const ProfilScreen()),
        ],
      ),
    ],
  );
});
