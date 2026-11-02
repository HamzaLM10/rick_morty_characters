import 'package:flutter/material.dart';
import 'package:rick_morty_characters/app/app_router.dart';
import 'package:rick_morty_characters/app/injection.dart';
import 'package:rick_morty_characters/core/theme/app_theme.dart';

void main() {
  configureDependencies();
  runApp(const CharactersApp());
}

class CharactersApp extends StatelessWidget {
  const CharactersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Characters',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}