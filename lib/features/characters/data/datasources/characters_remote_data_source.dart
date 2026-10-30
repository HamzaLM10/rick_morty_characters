import 'package:dio/dio.dart';
import 'package:rick_morty_characters/features/characters/data/models/character_model.dart';

class CharactersRemoteDataSource {
  const CharactersRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<CharacterModel>> getCharacters({String? name}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/character',
      queryParameters: {
        if (name != null && name.isNotEmpty) 'name': name,
      },
    );
    final results = response.data!['results'] as List<dynamic>;
    return results
        .map((json) => CharacterModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<CharacterModel> getCharacterById(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/character/$id');
    return CharacterModel.fromJson(response.data!);
  }
}