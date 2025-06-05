// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable implements Exception {
  final String? message;
  final String? code;

  const Failure({this.message, this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  bool get stringify => true;

  @override
  String toString() => 'Failure: $runtimeType(message: $message, code: $code)';
}

// General network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({super.message, super.code});
}

class ServerFailure extends Failure {
  const ServerFailure({String? message, super.code})
    : super(message: message ?? 'An unexpected server error occurred.');
}

// Represents errors related to local data storage (e.g., SharedPreferences, Hive)
class CacheFailure extends Failure {
  const CacheFailure({String? message})
    : super(message: message ?? 'Failed to access local data.');
}

// Represents cases where the application is unauthorized (e.g., 401, 403, invalid token)
// This can be used for both login failures and token refresh failures.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({String? message, super.code})
    : super(message: message ?? 'Authentication failed. Please log in again.');
}

// A catch-all for any unknown or unhandled exceptions
class UnknownFailure extends Failure {
  const UnknownFailure({String? message, super.code})
    : super(message: message ?? 'An unknown error occurred.');
}
