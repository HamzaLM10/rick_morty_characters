import 'package:dio/dio.dart';
import 'package:rick_morty_characters/features/characters/data/models/character_model.dart';
import 'package:rick_morty_characters/features/characters/data/models/paged_characters_model.dart';

class CharactersRemoteDataSource {
  const CharactersRemoteDataSource(this._dio);

  final Dio _dio;

  Future<PagedCharactersModel> getCharacters({
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
    return PagedCharactersModel.fromJson(response.data!);
  }

  Future<CharacterModel> getCharacterById(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/character/$id');
    return CharacterModel.fromJson(response.data!);
  }
}
