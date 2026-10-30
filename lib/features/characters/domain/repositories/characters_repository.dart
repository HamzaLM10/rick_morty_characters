import 'package:rick_morty_characters/features/characters/domain/entities/character.dart';

abstract interface class CharactersRepository {

  Future<List<Character>> getCharacters({String? name});

  Future<Character> getCharacterById(int id);
}