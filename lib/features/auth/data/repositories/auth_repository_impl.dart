import 'package:firebase_auth/firebase_auth.dart';
import 'package:rick_morty_characters/core/error/app_exception.dart';
import 'package:rick_morty_characters/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rick_morty_characters/features/auth/domain/entities/auth_user.dart';
import 'package:rick_morty_characters/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Stream<AuthUser?> authStateChanges() {
    return _remote.authStateChanges().map(
      (user) => user == null ? null : _toEntity(user),
    );
  }

  @override
  AuthUser? get currentUser {
    final user = _remote.currentUser;
    return user == null ? null : _toEntity(user);
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remote.signIn(email: email, password: password);
      return _toEntity(user);
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> signOut() => _remote.signOut();

  AuthUser _toEntity(User user) {
    return AuthUser(uid: user.uid, email: user.email ?? '');
  }

  AppException _mapError(FirebaseAuthException e) {
    return switch (e.code) {
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' ||
      'invalid-email' => const InvalidCredentialsException(),
      'too-many-requests' => const TooManyRequestsException(),
      'network-request-failed' => const NoInternetException(),
      _ => const UnknownException(),
    };
  }
}