import 'package:flutter/material.dart';

/// Couleurs du design system v1 (contraste ≥ 4,5:1 sur fond blanc pour le texte).
class AppColors {
  static const primary = Color(0xFF1E5AA8); // bleu, 6,8:1 sur blanc
  static const accent = Color(0xFFB45309); // ocre, 5,0:1 sur blanc
  static const success = Color(0xFF15803D); // vert, 5,0:1 sur blanc
  static const danger = Color(0xFFB91C1C); // rouge, 6,5:1 sur blanc
  static const text = Color(0xFF1B1F24);
  static const surface = Color(0xFFF6F8FB);
}

/// Seuil de passage en mise en page tablette (dp).
const double kTabletBreakpoint = 840;

/// Tout le style de l'application est centralisé ici : les widgets lisent
/// le thème (Theme.of(context)) et n'écrivent aucune couleur en dur.
ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.accent,
    error: AppColors.danger,
    surface: Colors.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.surface,
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.text),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.text),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.text),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.text),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
