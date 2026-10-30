import 'package:flutter/material.dart';
import 'package:rick_morty_characters/core/error/app_exception.dart';
import 'package:rick_morty_characters/core/network/dio_client.dart';
import 'package:rick_morty_characters/core/theme/app_theme.dart';
import 'package:rick_morty_characters/features/characters/data/datasources/characters_remote_data_source.dart';
import 'package:rick_morty_characters/features/characters/data/repositories/characters_repository_impl.dart';

Future<void> main() async {
  final repository = CharactersRepositoryImpl(
    CharactersRemoteDataSource(createDio()),
  );

  try {
    final all = await repository.getCharacters();
    debugPrint('TEST list: ${all.length} items, first = ${all.first}');

    final none = await repository.getCharacters(name: 'zzzzzzqq');
    debugPrint('TEST search no match: ${none.length} items');

    final one = await repository.getCharacterById(1);
    debugPrint('TEST details: ${one.name}, origin = ${one.origin}');

    await repository.getCharacterById(99999);
  } on AppException catch (e) {
    debugPrint('TEST caught: ${e.runtimeType} -> ${e.message}');
  }

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