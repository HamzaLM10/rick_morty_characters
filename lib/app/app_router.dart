import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_morty_characters/app/injection.dart';
import 'package:rick_morty_characters/core/router/app_routes.dart';
import 'package:rick_morty_characters/core/router/go_router_refresh_stream.dart';
import 'package:rick_morty_characters/features/auth/domain/repositories/auth_repository.dart';
import 'package:rick_morty_characters/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:rick_morty_characters/features/auth/presentation/pages/login_page.dart';
import 'package:rick_morty_characters/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:rick_morty_characters/features/characters/presentation/bloc/characters_event.dart';
import 'package:rick_morty_characters/features/characters/presentation/cubit/character_details_cubit.dart';
import 'package:rick_morty_characters/features/characters/presentation/pages/character_details_page.dart';
import 'package:rick_morty_characters/features/characters/presentation/pages/characters_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.characters,
  refreshListenable: GoRouterRefreshStream(
    sl<AuthRepository>().authStateChanges(),
  ),
  redirect: (context, state) {
    final isLoggedIn = sl<AuthRepository>().currentUser != null;
    final isOnLogin = state.matchedLocation == AppRoutes.login;

    if (!isLoggedIn) return isOnLogin ? null : AppRoutes.login;
    if (isOnLogin) return AppRoutes.characters;
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.characters,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<CharactersBloc>()..add(const CharactersStarted()),
          ),
          BlocProvider(create: (_) => sl<AuthCubit>()),
        ],
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