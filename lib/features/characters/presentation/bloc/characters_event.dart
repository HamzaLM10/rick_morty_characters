import 'package:equatable/equatable.dart';

sealed class CharactersEvent extends Equatable {
  const CharactersEvent();

  @override
  List<Object?> get props => [];
}

/// The page opened: load the first list.
final class CharactersStarted extends CharactersEvent {
  const CharactersStarted();
}

/// The user pressed Retry after an error.
final class CharactersRetried extends CharactersEvent {
  const CharactersRetried();
}

/// The text in the search field changed. An empty query means "all".
final class SearchQueryChanged extends CharactersEvent {
  const SearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}