import 'package:dio/dio.dart';
import 'package:rick_morty_characters/core/config/app_config.dart';

/// Creates the single Dio instance used by the app.
Dio createDio(AppConfig config) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  if (config.enableNetworkLogs) {
    // Dev only: print every request and its result.
    dio.interceptors.add(
      LogInterceptor(requestHeader: false, responseHeader: false),
    );
  }
  return dio;
}