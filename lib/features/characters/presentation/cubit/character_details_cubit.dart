import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty_characters/core/error/app_exception.dart';
import 'package:rick_morty_characters/features/characters/domain/repositories/characters_repository.dart';
import 'package:rick_morty_characters/features/characters/presentation/cubit/character_details_state.dart';

/// A Cubit (methods instead of events) is enough here: one action, `load`.
class CharacterDetailsCubit extends Cubit<CharacterDetailsState> {
  CharacterDetailsCubit(this._repository, this._id)
    : super(const CharacterDetailsInitial());

  final CharactersRepository _repository;
  final int _id;

  Future<void> load() async {
    emit(const CharacterDetailsLoading());
    try {
      final character = await _repository.getCharacterById(_id);
      // The user may have left the page while the request was running.
      if (isClosed) return;
      emit(CharacterDetailsLoaded(character));
    } on AppException catch (e) {
      if (isClosed) return;
      emit(CharacterDetailsError(e));
    }
  }
}