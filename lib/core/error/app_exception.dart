import 'package:equatable/equatable.dart';

/// Domain-level errors. The data layer converts network errors into these,
/// so the Bloc and the UI never see Dio types.
sealed class AppException extends Equatable implements Exception {
  const AppException(this.message);

  /// A message ready to be shown to the user.
  final String message;

  @override
  List<Object?> get props => [message];
}

final class NoInternetException extends AppException {
  const NoInternetException() : super("Can't connect .. check internet");
}

final class RequestTimeoutException extends AppException {
  const RequestTimeoutException()
    : super('The request took too long. Please try again.');
}

final class ServerException extends AppException {
  const ServerException() : super('Server error. Please try again later.');
}

final class NotFoundException extends AppException {
  const NotFoundException() : super('The requested item was not found.');
}

final class UnknownException extends AppException {
  const UnknownException() : super('Something went wrong.');
}
