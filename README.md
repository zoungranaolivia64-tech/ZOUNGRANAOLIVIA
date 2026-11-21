# CampusFlow

Application mobile (Flutter) de suivi des cours, échéances et tâches d'un étudiant.
TP de Programmation Mobile — Master 1 MSI, Université Aube Nouvelle de Ouagadougou.
Auteur : Zoungrana Olivia Séverine Wendyame.

## Contenu du dépôt

| Dossier | Séance | Contenu |
|---|---|---|
| `docs/seance1_decision_plateforme.docx` | 1 | Fiche comparative Android/iOS (14 critères), autopsie de Windows Phone, décision pour CampusFlow |
| `docs/seance2_conception_v1.docx` + `docs/wireframes/` | 2 | Persona, job stories, parcours, 5 wireframes (3 variantes de l'écran Échéances), design system v1 |
| `campusflow_models/` | 3 | Package Dart : `Task`, `Course`, `User`, `fromJson`, `copyWith`, dépôt simulé, tests |
| `campusflow/` | 4 à 7 | Application Flutter : thème, écrans, navigation GoRouter, état Riverpod, API Dio, authentification |
| `server/` | 7 | API simulée (json-server) avec `/login` et jeton |

## Lancer le projet

1. **Serveur** : `cd server && npm install && npm start` (ouvrir http://localhost:3000/taches).
   Pour la connexion avec jeton : `npm run start:auth`.
2. **Tests du package** : `cd campusflow_models && dart pub get && dart test`.
3. **Application** : `cd campusflow && flutter pub get && flutter run`.
4. **Connexion** : e-mail `etudiant@campusflow.bf`, mot de passe `campusflow`.

Sur l'émulateur Android, l'API est jointe par `10.0.2.2` (déjà géré dans `lib/core/dio_client.dart`).

## Architecture

- `core/` : thème (`ThemeData`), client Dio avec intercepteur de jeton, stockage sécurisé.
- `data/` : contrat `TaskRepository`, `ApiTaskRepository` (réseau), `FakeTaskRepository` (tests).
- `providers.dart` : état Riverpod (`TachesNotifier` en `AsyncNotifier`, filtres, authentification).
- `router.dart` : GoRouter avec `ShellRoute` et redirection vers `/login` sur 401.
- `screens/` : Échéances (téléphone et tablette ≥ 840 dp), Détail, Formulaire, Connexion, Cours, Profil.
