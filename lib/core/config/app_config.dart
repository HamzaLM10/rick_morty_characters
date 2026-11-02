import 'package:flutter/services.dart';

enum Flavor { dev, prod }

// Both flavors use the same public API: rickandmortyapi.com has no staging
// server. In a real project dev would point to a staging URL.
const String _apiUrl = 'https://rickandmortyapi.com/api';

/// Settings that differ between flavors. Built once, at startup.
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.baseUrl,
    required this.enableNetworkLogs,
  });

  /// `appFlavor` is the value given to `--flavor` (null if none was given).
  factory AppConfig.fromFlavor() {
    return switch (appFlavor) {
      'prod' => const AppConfig(
        flavor: Flavor.prod,
        baseUrl: _apiUrl,
        enableNetworkLogs: false,
      ),
      _ => const AppConfig(
        flavor: Flavor.dev,
        baseUrl: _apiUrl,
        enableNetworkLogs: true,
      ),
    };
  }

  final Flavor flavor;
  final String baseUrl;
  final bool enableNetworkLogs;

  bool get isDev => flavor == Flavor.dev;
}