#!/bin/bash
# Crée un commit par étape du projet. À lancer UNE FOIS depuis la racine du dépôt (Git Bash).
set -e
[ -d .git ] || git init -b main
c() { msg="$1"; shift; git add -- "$@" 2>/dev/null || true; git commit -m "$msg" || true; }

c "Séance 1 : fiche comparative, autopsie de Windows Phone et décision de plateforme" docs/seance1_decision_plateforme.docx
c "Séance 2 : persona, job stories et parcours utilisateur" docs/seance2_conception_v1.docx
c "Séance 2 : wireframes (5 écrans, 3 variantes) et design system v1" docs/wireframes
c "Séance 3 : création du package campusflow_models" campusflow_models/pubspec.yaml campusflow_models/analysis_options.yaml
c "Séance 3 : modèles Task, Course, User avec copyWith et fromJson" campusflow_models/lib
c "Séance 3 : dépôt simulé (Future.delayed) et 3 tests dart test" campusflow_models/test
c "Séance 4 : création du projet Flutter CampusFlow" campusflow/pubspec.yaml campusflow/analysis_options.yaml campusflow/lib/main.dart
c "Séance 4 : thème centralisé (ThemeData) issu du design system" campusflow/lib/core/theme.dart
c "Séance 4 : package intl et logo déclaré dans pubspec.yaml" campusflow/assets
c "Séance 5 : écran Échéances (ListView.builder, filtres) et version tablette à 840 dp" campusflow/lib/screens/echeances_screen.dart
c "Séance 5 : écran Détail et bouton Marquer comme fait" campusflow/lib/screens/detail_screen.dart campusflow/lib/screens/task_detail_view.dart
c "Séance 5 : formulaire de création de tâche avec validation" campusflow/lib/screens/form_screen.dart
c "Séance 6 : navigation GoRouter avec ShellRoute et barre de navigation" campusflow/lib/router.dart campusflow/lib/screens/shell_scaffold.dart campusflow/lib/screens/cours_screen.dart campusflow/lib/screens/profil_screen.dart
c "Séance 6 : état partagé Riverpod et filtres dérivés" campusflow/lib/providers.dart
c "Séance 7 : serveur json-server (db.json, /login, jeton)" server
c "Séance 7 : client Dio, contrat TaskRepository et implémentations API/Fake" campusflow/lib/core/dio_client.dart campusflow/lib/data
c "Séance 7 : stockage sécurisé du jeton et écran de connexion" campusflow/lib/core/token_storage.dart campusflow/lib/screens/login_screen.dart
c "Test de l'écran Échéances avec FakeTaskRepository" campusflow/test
c "Ajout du README, du guide d'installation et du .gitignore" README.md GUIDE_INSTALLATION.md .gitignore git_commits.sh
git add -A && (git commit -m "Derniers ajustements" || true)
git log --oneline | head -30
