import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty_characters/core/error/app_exception.dart';
import 'package:rick_morty_characters/features/characters/domain/repositories/characters_repository.dart';
import 'package:rick_morty_characters/features/characters/presentation/bloc/characters_event.dart';
import 'package:rick_morty_characters/features/characters/presentation/bloc/characters_state.dart';
import 'package:stream_transform/stream_transform.dart';

const Duration _searchDebounce = Duration(milliseconds: 400);

/// Waits until the user stops typing, then handles only the latest event
/// (an older request still in flight is cancelled).
EventTransformer<E> _debounceRestartable<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  CharactersBloc(this._repository) : super(const CharactersInitial()) {
    on<CharactersStarted>((event, emit) => _load('', emit));
    on<CharactersRetried>(_onRetried);
    on<SearchQueryChanged>(
      (event, emit) => _load(event.query.trim(), emit),
      transformer: _debounceRestartable(_searchDebounce),
    );
  }

  final CharactersRepository _repository;

  Future<void> _onRetried(
    CharactersRetried event,
    Emitter<CharactersState> emit,
  ) {
    final query = switch (state) {
      CharactersError(:final query) => query,
      _ => '',
    };
    return _load(query, emit);
  }

  Future<void> _load(String query, Emitter<CharactersState> emit) async {
    emit(const CharactersLoading());
    try {
      final characters = await _repository.getCharacters(name: query);
      emit(
        characters.isEmpty
            ? CharactersEmpty(query)
            : CharactersLoaded(characters, query),
      );
    } on AppException catch (e) {
      emit(CharactersError(e, query));
    }
  }
}