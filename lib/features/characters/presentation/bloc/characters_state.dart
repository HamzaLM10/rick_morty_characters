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
  const CharactersLoaded({
    required this.characters,
    required this.query,
    required this.page,
    required this.hasNextPage,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
  });

  final List<Character> characters;
  final String query;

  /// The last page that was loaded (starts at 1).
  final int page;
  final bool hasNextPage;

  /// A next page is being fetched (the list stays on screen).
  final bool isLoadingMore;

  /// Fetching the next page failed (the list stays on screen).
  final bool loadMoreFailed;

  CharactersLoaded copyWith({
    List<Character>? characters,
    int? page,
    bool? hasNextPage,
    bool? isLoadingMore,
    bool? loadMoreFailed,
  }) {
    return CharactersLoaded(
      characters: characters ?? this.characters,
      query: query,
      page: page ?? this.page,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
    );
  }

  @override
  List<Object?> get props => [
    characters,
    query,
    page,
    hasNextPage,
    isLoadingMore,
    loadMoreFailed,
  ];
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
