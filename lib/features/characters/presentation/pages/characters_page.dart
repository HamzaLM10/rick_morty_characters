import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty_characters/core/widgets/empty_view.dart';
import 'package:rick_morty_characters/core/widgets/error_view.dart';
import 'package:rick_morty_characters/features/characters/domain/entities/character.dart';
import 'package:rick_morty_characters/features/characters/domain/repositories/characters_repository.dart';
import 'package:rick_morty_characters/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:rick_morty_characters/features/characters/presentation/bloc/characters_event.dart';
import 'package:rick_morty_characters/features/characters/presentation/bloc/characters_state.dart';
import 'package:rick_morty_characters/features/characters/presentation/widgets/character_card.dart';
import 'package:rick_morty_characters/features/characters/presentation/widgets/characters_app_bar.dart';

/// Provides the Bloc. The drawing is done by [_CharactersView].
class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CharactersBloc(context.read<CharactersRepository>())
        ..add(const CharactersStarted()),
      child: const _CharactersView(),
    );
  }
}

class _CharactersView extends StatelessWidget {
  const _CharactersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CharactersAppBar(
        onQueryChanged: (query) =>
            context.read<CharactersBloc>().add(SearchQueryChanged(query)),
      ),
      body: BlocBuilder<CharactersBloc, CharactersState>(
        builder: (context, state) => switch (state) {
          CharactersInitial() ||
          CharactersLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          CharactersLoaded(:final characters) => _CharactersGrid(
            characters: characters,
          ),
          CharactersEmpty(:final query) => EmptyView(
            message: 'No characters found for "$query"',
          ),
          CharactersError(:final exception) => ErrorView(
            exception: exception,
            onRetry: () =>
                context.read<CharactersBloc>().add(const CharactersRetried()),
          ),
        },
      ),
    );
  }
}

class _CharactersGrid extends StatelessWidget {
  const _CharactersGrid({required this.characters});

  final List<Character> characters;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2 / 3,
      ),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        return CharacterCard(
          character: characters[index],
          // Navigation to the details page is added in step 7.
          onTap: () {},
        );
      },
    );
  }
}