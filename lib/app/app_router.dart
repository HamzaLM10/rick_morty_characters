import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_morty_characters/app/injection.dart';
import 'package:rick_morty_characters/core/router/app_routes.dart';
import 'package:rick_morty_characters/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:rick_morty_characters/features/characters/presentation/bloc/characters_event.dart';
import 'package:rick_morty_characters/features/characters/presentation/cubit/character_details_cubit.dart';
import 'package:rick_morty_characters/features/characters/presentation/pages/character_details_page.dart';
import 'package:rick_morty_characters/features/characters/presentation/pages/characters_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.characters,
  routes: [
    GoRoute(
      path: AppRoutes.characters,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<CharactersBloc>()..add(const CharactersStarted()),
        child: const CharactersPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.characterDetails,
      builder: (context, state) {
        // Only our own code builds this path, always with an int id.
        final id = int.parse(state.pathParameters['id']!);
        return BlocProvider(
          create: (_) => sl<CharacterDetailsCubit>(param1: id)..load(),
          child: const CharacterDetailsPage(),
        );
      },
    ),
  ],
);