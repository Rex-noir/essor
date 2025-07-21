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
  const NetworkFailure({String? message, String? code})
    : super(
        message: message ?? 'Network error occurred.',
        code: code ?? 'ne-err',
      );
}

class ServerFailure extends Failure {
  const ServerFailure({String? message, String? code})
    : super(
        message: message ?? 'An unexpected server error occurred.',
        code: code ?? 'ser-err',
      );
}

class CacheFailure extends Failure {
  const CacheFailure({String? message, String? code})
    : super(
        message: message ?? 'Failed to access local data.',
        code: code ?? 'cache_error',
      );
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({String? message, String? code})
    : super(
        message: message ?? 'Authentication failed. Please log in again.',
        code: code ?? 'unau-err',
      );
}

class UnknownFailure extends Failure {
  const UnknownFailure({String? message, String? code})
    : super(
        message: message ?? 'An unknown error occurred.',
        code: code ?? 'unknown-err',
      );
}
