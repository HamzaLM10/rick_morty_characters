import 'package:equatable/equatable.dart';
import 'package:rick_morty_characters/core/error/app_exception.dart';
import 'package:rick_morty_characters/features/characters/domain/entities/character.dart';

sealed class CharacterDetailsState extends Equatable {
  const CharacterDetailsState();

  @override
  List<Object?> get props => [];
}

final class CharacterDetailsInitial extends CharacterDetailsState {
  const CharacterDetailsInitial();
}

final class CharacterDetailsLoading extends CharacterDetailsState {
  const CharacterDetailsLoading();
}

final class CharacterDetailsLoaded extends CharacterDetailsState {
  const CharacterDetailsLoaded(this.character);

  final Character character;

  @override
  List<Object?> get props => [character];
}

final class CharacterDetailsError extends CharacterDetailsState {
  const CharacterDetailsError(this.exception);

  final AppException exception;

  @override
  List<Object?> get props => [exception];
}