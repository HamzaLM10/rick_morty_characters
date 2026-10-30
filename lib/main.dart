import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty_characters/core/network/dio_client.dart';
import 'package:rick_morty_characters/core/theme/app_theme.dart';
import 'package:rick_morty_characters/features/characters/data/datasources/characters_remote_data_source.dart';
import 'package:rick_morty_characters/features/characters/data/repositories/characters_repository_impl.dart';
import 'package:rick_morty_characters/features/characters/domain/repositories/characters_repository.dart';
import 'package:rick_morty_characters/features/characters/presentation/pages/characters_page.dart';

void main() {
  runApp(const CharactersApp());
}

class CharactersApp extends StatelessWidget {
  const CharactersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<CharactersRepository>(
      create: (_) => CharactersRepositoryImpl(
        CharactersRemoteDataSource(createDio()),
      ),
      child: MaterialApp(
        title: 'Characters',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const CharactersPage(),
      ),
    );
  }
}