import 'package:equatable/equatable.dart';
import 'package:rick_morty_characters/core/error/app_exception.dart';
import 'package:rick_morty_characters/features/characters/domain/entities/character.dart';

sealed class CharactersState extends Equatable {
  const CharactersState();

  @override
  List<Object?> get props => [];
}

final class CharactersInitial extends CharactersState {
  const CharactersInitial();
}

final class CharactersLoading extends CharactersState {
  const CharactersLoading();
}

final class CharactersLoaded extends CharactersState {
  const CharactersLoaded(this.characters, this.query);

  final List<Character> characters;
  final String query;

  @override
  List<Object?> get props => [characters, query];
}

/// A search that matched nothing. Not an error.
final class CharactersEmpty extends CharactersState {
  const CharactersEmpty(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class CharactersError extends CharactersState {
  const CharactersError(this.exception, this.query);

  final AppException exception;
  final String query;

  @override
  List<Object?> get props => [exception, query];
}