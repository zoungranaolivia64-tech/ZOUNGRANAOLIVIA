import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'token_storage.dart';

/// Sur l'émulateur Android, l'ordinateur hôte s'appelle 10.0.2.2 (et non localhost).
String get apiBaseUrl {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:3000';
  }
  return 'http://localhost:3000';
}

/// Client Dio : ajoute le jeton à chaque requête (intercepteur) et signale
/// les réponses 401 pour rediriger vers l'écran de connexion.
Dio createDio({
  required TokenStorage storage,
  required Future<void> Function() onUnauthorized,
}) {
  final dio = Dio(BaseOptions(
    baseUrl: apiBaseUrl,
    connectTimeout: const Duration(seconds: 6),
    receiveTimeout: const Duration(seconds: 6),
    headers: {'Content-Type': 'application/json'},
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await storage.read();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    onError: (error, handler) async {
      final isLogin = error.requestOptions.path == '/login';
      if (error.response?.statusCode == 401 && !isLogin) {
        await onUnauthorized();
      }
      handler.next(error);
    },
  ));
  return dio;
}
