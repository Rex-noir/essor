import 'package:mobile/core/domain/failures/failures.dart';

class InvalidCredentialsFailure extends UnauthorizedFailure {
  const InvalidCredentialsFailure({String? message})
    : super(message: message ?? 'Invalid email or password.');
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure({String? message})
    : super(message: message ?? 'User not found.');
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure({String? message})
    : super(message: message ?? 'This email is already registered.');
}

class UserDisabledFailure extends Failure {
  const UserDisabledFailure({String? message})
    : super(message: message ?? 'Your account has been disabled.');
}

class ValidationFailure extends Failure {
  final Map<String, String>? errors; // Map of field name to error message
  const ValidationFailure({String? message, this.errors})
    : super(message: message ?? 'Input validation failed.');

  @override
  List<Object?> get props => [...super.props, errors];
}

class TokenExpiredFailure extends UnauthorizedFailure {
  const TokenExpiredFailure({String? message})
    : super(
        message: message ?? 'Your session has expired. Please log in again.',
      );
}

class TokenInvalidFailure extends UnauthorizedFailure {
  const TokenInvalidFailure({String? message})
    : super(
        message: message ?? 'Your session is invalid. Please log in again.',
      );
}
