import 'package:dio/dio.dart';

const String _baseUrl = 'https://rickandmortyapi.com/api';

/// Creates the single Dio instance used by the app.
Dio createDio() {
  return Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );
}