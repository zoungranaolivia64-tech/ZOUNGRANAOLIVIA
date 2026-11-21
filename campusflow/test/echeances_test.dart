import 'package:campusflow/core/theme.dart';
import 'package:campusflow/data/fake_task_repository.dart';
import 'package:campusflow/providers.dart';
import 'package:campusflow/screens/echeances_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('fr'));

  testWidgets('la liste affiche les tâches à faire du dépôt simulé', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [taskRepositoryProvider.overrideWithValue(FakeTaskRepository())],
      child: MaterialApp(theme: buildTheme(), home: const EcheancesScreen()),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Rendre le TP de Programmation Mobile'), findsOneWidget);
    expect(find.text('Exposé terminé'), findsNothing); // tâche faite : filtre « À faire »
  });
}
