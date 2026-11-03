import 'package:rick_morty_characters/features/auth/domain/entities/auth_user.dart';

abstract interface class AuthRepository {
  Stream<AuthUser?> authStateChanges();

  AuthUser? get currentUser;

  Future<AuthUser> signIn({required String email, required String password});

  Future<void> signOut();
}