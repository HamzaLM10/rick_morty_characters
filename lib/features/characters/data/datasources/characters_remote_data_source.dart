import 'package:dio/dio.dart';

/// Talks to the API and returns the raw JSON. It knows nothing about models.
class CharactersRemoteDataSource {
  const CharactersRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> getCharacters({
    String? name,
    int page = 1,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/character',
      queryParameters: {
        'page': page,
        if (name != null && name.isNotEmpty) 'name': name,
      },
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> getCharacterById(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/character/$id');
    return response.data!;
  }
}