import 'package:rick_morty_characters/features/characters/domain/entities/character.dart';
import 'package:rick_morty_characters/features/characters/domain/entities/paged_characters.dart';

abstract interface class CharactersRepository {
  Future<PagedCharacters> getCharacters({String? name, int page = 1});

  /// Throws a [NotFoundException] if no character has this [id].
  /// Throws another [AppException] on other failures.
  Future<Character> getCharacterById(int id);
}
