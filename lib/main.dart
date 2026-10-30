import 'package:flutter/material.dart';
import 'package:rick_morty_characters/core/network/dio_client.dart';
import 'package:rick_morty_characters/core/theme/app_theme.dart';
import 'package:rick_morty_characters/features/characters/data/datasources/characters_remote_data_source.dart';
import 'package:rick_morty_characters/features/characters/data/repositories/characters_repository_impl.dart';
import 'package:rick_morty_characters/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:rick_morty_characters/features/characters/presentation/bloc/characters_event.dart';
import 'package:rick_morty_characters/features/characters/presentation/bloc/characters_state.dart';

String _describe(CharactersState state) => switch (state) {
  CharactersInitial() => 'Initial',
  CharactersLoading() => 'Loading',
  CharactersLoaded(:final characters, :final query) =>
    'Loaded(${characters.length}, "$query")',
  CharactersEmpty(:final query) => 'Empty("$query")',
  CharactersError(:final exception) => 'Error(${exception.runtimeType})',
};

Future<void> main() async {
  final bloc = CharactersBloc(
    CharactersRepositoryImpl(CharactersRemoteDataSource(createDio())),
  );
  bloc.stream.listen((state) => debugPrint('STATE: ${_describe(state)}'));

  const pause = Duration(seconds: 3);

  debugPrint('--- start');
  bloc.add(const CharactersStarted());
  await Future<void>.delayed(pause);

  debugPrint('--- fast typing r, ri, rick');
  bloc.add(const SearchQueryChanged('r'));
  bloc.add(const SearchQueryChanged('ri'));
  bloc.add(const SearchQueryChanged('rick'));
  await Future<void>.delayed(pause);

  debugPrint('--- no match');
  bloc.add(const SearchQueryChanged('zzzzzzqq'));
  await Future<void>.delayed(pause);

  debugPrint('--- cleared');
  bloc.add(const SearchQueryChanged(''));
  await Future<void>.delayed(pause);

  await bloc.close();
  runApp(const CharactersApp());
}

class CharactersApp extends StatelessWidget {
  const CharactersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Characters',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Characters'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
        ),
        body: const Center(child: Text('Hello')),
      ),
    );
  }
}