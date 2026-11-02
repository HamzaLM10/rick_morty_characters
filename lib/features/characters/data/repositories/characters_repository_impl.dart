import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rick_morty_characters/core/error/app_exception.dart';
import 'package:rick_morty_characters/features/characters/data/datasources/characters_local_data_source.dart';
import 'package:rick_morty_characters/features/characters/data/datasources/characters_remote_data_source.dart';
import 'package:rick_morty_characters/features/characters/data/models/character_model.dart';
import 'package:rick_morty_characters/features/characters/data/models/paged_characters_model.dart';
import 'package:rick_morty_characters/features/characters/domain/entities/character.dart';
import 'package:rick_morty_characters/features/characters/domain/entities/paged_characters.dart';
import 'package:rick_morty_characters/features/characters/domain/repositories/characters_repository.dart';

/// Network first. When the network fails, falls back to what was cached.
class CharactersRepositoryImpl implements CharactersRepository {
  const CharactersRepositoryImpl({
    required CharactersRemoteDataSource remote,
    required CharactersLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  final CharactersRemoteDataSource _remote;
  final CharactersLocalDataSource _local;

  @override
  Future<PagedCharacters> getCharacters({String? name, int page = 1}) async {
    final key = _listKey(name, page);
    try {
      final json = await _remote.getCharacters(name: name, page: page);
      // Parse first: only data we understand is ever cached.
      final result = PagedCharactersModel.fromJson(json).toEntity();
      await _local.save(key, json);
      await _cacheEachCharacter(json);
      return result;
    } on DioException catch (e) {
      // The API answers 404 when a search matches nothing: not an error.
      if (e.response?.statusCode == 404) {
        return const PagedCharacters(characters: [], hasNextPage: false);
      }
      final exception = _mapDioException(e);
      final cached = _readCachedPage(key);
      if (cached != null && _isConnectionProblem(exception)) return cached;
      throw exception;
    } on TypeError {
      // Unexpected JSON shape.
      throw const UnknownException();
    }
  }

  @override
  Future<Character> getCharacterById(int id) async {
    final key = _characterKey(id);
    try {
      final json = await _remote.getCharacterById(id);
      final character = CharacterModel.fromJson(json).toEntity();
      await _local.save(key, json);
      return character;
    } on DioException catch (e) {
      final exception = _mapDioException(e);
      final cached = _readCachedCharacter(key);
      if (cached != null && _isConnectionProblem(exception)) return cached;
      throw exception;
    } on TypeError {
      throw const UnknownException();
    }
  }

  // ---- cache helpers -------------------------------------------------

  String _listKey(String? name, int page) =>
      'list:${(name ?? '').trim().toLowerCase()}:$page';

  String _characterKey(int id) => 'character:$id';

  /// Every character in a list page has the same JSON shape as the details
  /// endpoint, so we cache each one: details then work offline for anything
  /// the user has seen in a list.
  Future<void> _cacheEachCharacter(Map<String, dynamic> pageJson) async {
    for (final item in pageJson['results'] as List<dynamic>) {
      final character = item as Map<String, dynamic>;
      await _local.save(_characterKey(character['id'] as int), character);
    }
  }

  PagedCharacters? _readCachedPage(String key) {
    final json = _local.read(key);
    if (json == null) return null;
    try {
      return PagedCharactersModel.fromJson(json).toEntity();
    } on TypeError {
      return null;
    }
  }

  Character? _readCachedCharacter(String key) {
    final json = _local.read(key);
    if (json == null) return null;
    try {
      return CharacterModel.fromJson(json).toEntity();
    } on TypeError {
      return null;
    }
  }

  /// Cached data is a good answer to these failures, not to "not found".
  bool _isConnectionProblem(AppException e) {
    return e is NoInternetException ||
        e is RequestTimeoutException ||
        e is ServerException;
  }

  // ---- error mapping (unchanged) -------------------------------------

  AppException _mapDioException(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionError => const NoInternetException(),
      DioExceptionType.unknown when e.error is SocketException =>
        const NoInternetException(),
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const RequestTimeoutException(),
      DioExceptionType.badResponse => _fromStatusCode(e.response?.statusCode),
      _ => const UnknownException(),
    };
  }

  AppException _fromStatusCode(int? statusCode) {
    if (statusCode == 404) return const NotFoundException();
    if (statusCode != null && statusCode >= 500) return const ServerException();
    return const UnknownException();
  }
}