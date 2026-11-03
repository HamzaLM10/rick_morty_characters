import 'package:equatable/equatable.dart';
import 'package:rick_morty_characters/core/error/app_exception.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthFailure extends AuthState {
  const AuthFailure(this.exception);

  final AppException exception;

  @override
  List<Object?> get props => [exception];
}