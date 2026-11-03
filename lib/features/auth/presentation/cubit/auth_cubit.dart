import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty_characters/core/error/app_exception.dart';
import 'package:rick_morty_characters/features/auth/domain/repositories/auth_repository.dart';
import 'package:rick_morty_characters/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthInitial());

  final AuthRepository _repository;

  Future<void> signIn({required String email, required String password}) async {
    if (state is AuthLoading) return;
    emit(const AuthLoading());
    try {
      await _repository.signIn(email: email.trim(), password: password);
      if (isClosed) return;
      emit(const AuthInitial());
    } on AppException catch (e) {
      if (isClosed) return;
      emit(AuthFailure(e));
    } catch (_) {
      if (isClosed) return;
      emit(const AuthFailure(UnknownException()));
    }
  }

  Future<void> signOut() => _repository.signOut();
}