import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rick_morty_characters/core/error/app_exception.dart';
import 'package:rick_morty_characters/features/characters/data/datasources/characters_remote_data_source.dart';
import 'package:rick_morty_characters/features/characters/domain/entities/character.dart';
import 'package:rick_morty_characters/features/characters/domain/repositories/characters_repository.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  const CharactersRepositoryImpl(this._remote);

  final CharactersRemoteDataSource _remote;

  @override
  Future<List<Character>> getCharacters({String? name}) async {
    try {
      final models = await _remote.getCharacters(name: name);
      return models.map((model) => model.toEntity()).toList();
    } on DioException catch (e) {
      // The API answers 404 when a search matches nothing: not an error.
      if (e.response?.statusCode == 404) return const [];
      throw _mapDioException(e);
    } on TypeError {
      // Unexpected JSON shape.
      throw const UnknownException();
    }
  }

  @override
  Future<Character> getCharacterById(int id) async {
    try {
      final model = await _remote.getCharacterById(id);
      return model.toEntity();
    } on DioException catch (e) {
      throw _mapDioException(e);
    } on TypeError {
      throw const UnknownException();
    }
  }

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