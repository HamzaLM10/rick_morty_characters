import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_morty_characters/core/router/app_routes.dart';
import 'package:rick_morty_characters/core/widgets/empty_view.dart';
import 'package:rick_morty_characters/core/widgets/error_view.dart';
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
      create: (context) =>
          CharactersBloc(context.read<CharactersRepository>())
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
          CharactersInitial() || CharactersLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          final CharactersLoaded loaded => _CharactersGrid(state: loaded),
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

class _CharactersGrid extends StatefulWidget {
  const _CharactersGrid({required this.state});

  final CharactersLoaded state;

  @override
  State<_CharactersGrid> createState() => _CharactersGridState();
}

class _CharactersGridState extends State<_CharactersGrid> {
  /// Start loading the next page when this close to the end of the list.
  static const double _loadMoreThreshold = 400;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = widget.state;
    if (!state.hasNextPage || state.isLoadingMore || state.loadMoreFailed) {
      return;
    }
    final position = _controller.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      _requestNextPage();
    }
  }

  void _requestNextPage() {
    context.read<CharactersBloc>().add(const NextPageRequested());
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final characters = state.characters;

    return CustomScrollView(
      controller: _controller,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid.builder(
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
                onTap: () => context.push(
                  AppRoutes.characterDetailsPath(characters[index].id),
                ),
              );
            },
          ),
        ),
        if (state.isLoadingMore || state.loadMoreFailed)
          SliverToBoxAdapter(
            child: _LoadMoreFooter(
              isLoading: state.isLoadingMore,
              onRetry: _requestNextPage,
            ),
          ),
      ],
    );
  }
}

class _LoadMoreFooter extends StatelessWidget {
  const _LoadMoreFooter({required this.isLoading, required this.onRetry});

  final bool isLoading;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 3),
              )
            : TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text("Couldn't load more. Tap to retry"),
              ),
      ),
    );
  }
}
