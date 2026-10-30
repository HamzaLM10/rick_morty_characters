import 'package:rick_morty_characters/features/characters/data/models/character_model.dart';
import 'package:rick_morty_characters/features/characters/domain/entities/paged_characters.dart';

/// The `{ info, results }` response of the list endpoint.
class PagedCharactersModel {
  const PagedCharactersModel({
    required this.characters,
    required this.hasNextPage,
  });

  factory PagedCharactersModel.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List<dynamic>;
    final info = json['info'] as Map<String, dynamic>;
    return PagedCharactersModel(
      characters: results
          .map((item) => CharacterModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      hasNextPage: info['next'] != null,
    );
  }

  final List<CharacterModel> characters;
  final bool hasNextPage;

  PagedCharacters toEntity() {
    return PagedCharacters(
      characters: characters.map((model) => model.toEntity()).toList(),
      hasNextPage: hasNextPage,
    );
  }
}
