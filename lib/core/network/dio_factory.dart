import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:auto_guessr_mobile/core/config/app_config.dart';
import 'package:auto_guessr_mobile/core/network/auth_interceptor.dart';
import 'package:auto_guessr_mobile/core/storage/token_storage.dart';

/// Crée l'unique instance de Dio partagée par toutes les features.
Dio createDio({
  required TokenStorage tokenStorage,
  required void Function() onUnauthorized,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(tokenStorage: tokenStorage, onUnauthorized: onUnauthorized),
  );

  // Logs HTTP complets en debug uniquement (ils contiennent mots de passe et
  // tokens : ils ne doivent jamais partir en production).
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (line) => debugPrint(line.toString()),
      ),
    );
  }

  return dio;
}
