# Guide d'installation pas à pas (Windows)

## A. Installer les outils (une seule fois)
1. **Git** : https://git-scm.com/download/win
2. **Node.js (LTS)** : https://nodejs.org (pour json-server)
3. **Flutter SDK** : https://docs.flutter.dev/get-started/install/windows — dézipper dans `C:\src\flutter` et ajouter `C:\src\flutter\bin` au PATH.
4. **Android Studio** : installer, puis *More Actions > SDK Manager* pour installer le SDK Android, puis *Device Manager* pour créer un émulateur.
5. Dans un terminal : `flutter doctor --android-licenses` (accepter tout), puis `flutter doctor`.
   Corriger chaque ligne en erreur. Les avertissements Chrome / Visual Studio ne sont pas bloquants.

## B. Préparer le projet Flutter
Dézipper le dépôt, puis :
```
cd campusflow
flutter create --platforms=android,web .
flutter pub get
```
`flutter create .` ajoute les dossiers `android/` et `web/` sans écraser `lib/` ni `pubspec.yaml` (vérifier avec `git status`).

### Deux réglages Android obligatoires
1. **Autoriser le HTTP local** : dans `android/app/src/main/AndroidManifest.xml`, ajouter dans la balise `<application ...>` :
   `android:usesCleartextTraffic="true"`
2. **Stockage sécurisé** : dans `android/app/build.gradle` (ou `build.gradle.kts`), mettre `minSdk = 23` (ou `minSdkVersion 23`) dans `defaultConfig`.

## C. Lancer
Terminal 1 (serveur) :
```
cd server
npm install
npm run start:auth
```
Terminal 2 (application, émulateur démarré) :
```
cd campusflow
flutter run
```
Connexion : `etudiant@campusflow.bf` / `campusflow`.

## D. Tests
```
cd campusflow_models && dart pub get && dart test
cd ../campusflow && flutter test
```

## E. Commits et GitHub
1. Créer un dépôt vide sur GitHub (public).
2. Dans le dossier du dépôt : `git init`, puis lancer `bash git_commits.sh` (Git Bash) pour créer un commit par étape.
3. `git branch -M main`, `git remote add origin <URL>`, `git push -u origin main`.
4. Ouvrir le lien dans une fenêtre de navigation privée, puis l'envoyer à moctar.compaore@gmail.com avant le dimanche 22 novembre à 23h59.

## Problèmes fréquents
- **Écran de connexion : « Serveur injoignable »** : vérifier que `npm run start:auth` tourne et que l'émulateur utilise bien `10.0.2.2`.
- **Erreur de compilation sur `flutter_secure_storage`** : vérifier `minSdk 23`.
- **`RenderFlex overflowed`** : entourer le widget fautif d'un `Expanded` ou le rendre défilant.
