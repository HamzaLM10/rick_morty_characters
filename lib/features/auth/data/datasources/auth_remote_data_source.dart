import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._auth);

  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(code: 'null-user');
    }
    return user;
  }

  Future<void> signOut() => _auth.signOut();
}