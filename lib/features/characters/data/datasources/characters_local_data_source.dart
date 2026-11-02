import 'dart:convert';

import 'package:hive_ce_flutter/hive_flutter.dart';

/// Keeps the API's raw JSON on the device (Hive CE), so the app can show
/// something when the network fails. Caching is best-effort: a failure here
/// never breaks the app.
class CharactersLocalDataSource {
  const CharactersLocalDataSource(this._box);

  /// Prepares Hive and opens the cache box. Called once, at startup.
  static Future<CharactersLocalDataSource> open() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<String>('characters_cache');
    return CharactersLocalDataSource(box);
  }

  final Box<String> _box;

  Future<void> save(String key, Map<String, dynamic> json) async {
    try {
      await _box.put(key, jsonEncode(json));
    } catch (_) {
      // Ignore: the app works without a cache.
    }
  }

  /// Returns null when nothing is stored, or when the entry is corrupt.
  Map<String, dynamic>? read(String key) {
    final raw = _box.get(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}