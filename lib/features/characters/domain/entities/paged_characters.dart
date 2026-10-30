import 'package:equatable/equatable.dart';
import 'package:rick_morty_characters/features/characters/domain/entities/character.dart';

/// One page of results plus whether another page exists.
class PagedCharacters extends Equatable {
  const PagedCharacters({required this.characters, required this.hasNextPage});

  final List<Character> characters;
  final bool hasNextPage;

  @override
  List<Object?> get props => [characters, hasNextPage];
}
