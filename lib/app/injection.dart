import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_morty_characters/core/network/dio_client.dart';
import 'package:rick_morty_characters/features/characters/data/datasources/characters_remote_data_source.dart';
import 'package:rick_morty_characters/features/characters/data/repositories/characters_repository_impl.dart';
import 'package:rick_morty_characters/features/characters/domain/repositories/characters_repository.dart';
import 'package:rick_morty_characters/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:rick_morty_characters/features/characters/presentation/cubit/character_details_cubit.dart';

/// The app's DI container (service locator).
final GetIt sl = GetIt.instance;

/// Says how every object is built. Called once, from main().
void configureDependencies() {
  // Network: one Dio for the whole app.
  sl.registerLazySingleton<Dio>(createDio);

  // Data layer.
  sl.registerLazySingleton<CharactersRemoteDataSource>(
    () => CharactersRemoteDataSource(sl()),
  );

  // The domain contract and the class that implements it.
  sl.registerLazySingleton<CharactersRepository>(
    () => CharactersRepositoryImpl(sl()),
  );

  // Presentation: a NEW instance for every screen.
  sl.registerFactory<CharactersBloc>(() => CharactersBloc(sl()));

  // This Cubit needs the character id, passed when it is requested.
  sl.registerFactoryParam<CharacterDetailsCubit, int, void>(
    (id, _) => CharacterDetailsCubit(sl(), id),
  );
}