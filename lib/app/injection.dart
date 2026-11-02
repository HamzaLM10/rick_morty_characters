import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_morty_characters/core/config/app_config.dart';
import 'package:rick_morty_characters/core/network/dio_client.dart';
import 'package:rick_morty_characters/features/characters/data/datasources/characters_local_data_source.dart';
import 'package:rick_morty_characters/features/characters/data/datasources/characters_remote_data_source.dart';
import 'package:rick_morty_characters/features/characters/data/repositories/characters_repository_impl.dart';
import 'package:rick_morty_characters/features/characters/domain/repositories/characters_repository.dart';
import 'package:rick_morty_characters/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:rick_morty_characters/features/characters/presentation/cubit/character_details_cubit.dart';

/// The app's DI container (service locator).
final GetIt sl = GetIt.instance;

/// Says how every object is built. Called once, from main().
Future<void> configureDependencies(AppConfig config) async {
  // The active flavor's settings, available to anyone who asks.
  sl.registerSingleton<AppConfig>(config);

  // Network: one Dio for the whole app, built from the config.
  sl.registerLazySingleton<Dio>(() => createDio(sl()));

  // The cache must be opened (async) before anyone can use it.
  sl.registerSingleton<CharactersLocalDataSource>(
    await CharactersLocalDataSource.open(),
  );

  sl.registerLazySingleton<CharactersRemoteDataSource>(
    () => CharactersRemoteDataSource(sl()),
  );

  // The domain contract and the class that implements it.
  sl.registerLazySingleton<CharactersRepository>(
    () => CharactersRepositoryImpl(remote: sl(), local: sl()),
  );

  // Presentation: a NEW instance for every screen.
  sl.registerFactory<CharactersBloc>(() => CharactersBloc(sl()));

  // This Cubit needs the character id, passed when it is requested.
  sl.registerFactoryParam<CharacterDetailsCubit, int, void>(
    (id, _) => CharacterDetailsCubit(sl(), id),
  );
}