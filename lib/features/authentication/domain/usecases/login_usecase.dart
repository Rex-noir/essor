import 'package:dio/dio.dart';
import 'package:mobile/core/domain/failures/failures.dart';
import 'package:mobile/features/authentication/domain/failures/auth_failures.dart';
import 'package:mobile/features/authentication/domain/repositories/auth_token_storage_repository.dart';
import 'package:mobile/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:mobile/features/profile/domain/entities/user_entity.dart';

class LoginUseCase {
  final AuthTokenStorageRepository _authTokenStorageRepository;
  final AuthenticationRepository _authenticationRepository;

  const LoginUseCase({
    required AuthTokenStorageRepository authTokenStorageRepository,
    required AuthenticationRepository authenticationRepository,
  }) : _authTokenStorageRepository = authTokenStorageRepository,
       _authenticationRepository = authenticationRepository;

  Future<UserEntity> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authenticationRepository.logIn(
        email: email,
        password: password,
      );

      _authTokenStorageRepository.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        deviceId: response.deviceId,
      );

      return response.data;
    } on DioException catch (e) {
      String? backendMessage;
      if (e.response?.data is Map<String, dynamic> &&
          e.response!.data.containsKey('message')) {
        backendMessage = e.response!.data['message'] as String?;
      }

      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkFailure(
          message:
              backendMessage ??
              'No internet connection. Please check your network.',
        );
      } else if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 401:
            throw InvalidCredentialsFailure(
              message: backendMessage ?? 'Invalid email or password.',
            );
          case 403:
            throw UserDisabledFailure(
              // Or UnauthorizedFailure for general 403
              message:
                  backendMessage ?? 'Access denied or account is inactive.',
            );
          case 404:
            throw UserNotFoundFailure(
              message: backendMessage ?? 'User not found.',
            );
          case 409:
            throw EmailAlreadyInUseFailure(
              message: backendMessage ?? 'This email is already registered.',
            );
          case int statusCode when statusCode >= 500:
            throw ServerFailure(
              message:
                  backendMessage ?? 'Server error. Please try again later.',
              code: statusCode.toString(),
            );
          default:
            throw ServerFailure(
              message: backendMessage ?? 'An unexpected API error occurred.',
              code: statusCode.toString(),
            );
        }
      } else {
        throw UnknownFailure(
          message:
              backendMessage ?? 'An unexpected error occurred: ${e.message}',
        );
      }
    } on Exception catch (e) {
      throw UnknownFailure(
        message: 'An unforeseen application error occurred: ${e.toString()}',
      );
    }
  }
}
