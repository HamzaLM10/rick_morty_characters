import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rick_morty_characters/app/app_router.dart';
import 'package:rick_morty_characters/app/injection.dart';
import 'package:rick_morty_characters/core/config/app_config.dart';
import 'package:rick_morty_characters/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final config = AppConfig.fromFlavor();
  await configureDependencies(config);
  runApp(CharactersApp(config: config));
}

class CharactersApp extends StatelessWidget {
  const CharactersApp({super.key, required this.config});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: config.isDev ? 'Characters Dev' : 'Characters',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: appRouter,
      builder: (context, child) {
        final app = child ?? const SizedBox.shrink();
        if (!config.isDev) return app;
        return Banner(
          message: 'DEV',
          location: BannerLocation.topStart,
          textDirection: TextDirection.ltr,
          layoutDirection: TextDirection.ltr,
          child: app,
        );
      },
    );
  }
}