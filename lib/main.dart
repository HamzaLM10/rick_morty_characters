import 'package:rick_morty_characters/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
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