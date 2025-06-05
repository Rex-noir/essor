import 'package:dio/dio.dart';
import 'package:mobile/core/failures/failures.dart';
import 'package:mobile/features/authentication/domain/repositories/auth_token_storage_repository.dart';
import 'package:mobile/features/authentication/domain/repositories/authentication_repository.dart';

class LogoutUseCase {
  final AuthenticationRepository _authenticationRepository;
  final AuthTokenStorageRepository _authTokenStorageRepository;

  LogoutUseCase({
    required AuthTokenStorageRepository authTokenStorageRepository,
    required AuthenticationRepository authenticationRepository,
  }) : _authTokenStorageRepository = authTokenStorageRepository,
       _authenticationRepository = authenticationRepository;

  Future<void> call() async {
    try {
      final refreshToken = _authTokenStorageRepository.accessToken;
      final deviceId = _authTokenStorageRepository.deviceId;

      await _authenticationRepository.logOut(
        refreshToken: refreshToken,
        deviceId: deviceId,
      );
    } on DioException catch (e) {
      String? backendMessage;
      if (e.response?.data is Map<String, dynamic> &&
          e.response!.data.containsKey('message')) {
        backendMessage = e.response!.data['message'] as String?;
      }
      // Even if remote logout fails, we still clear local tokens.
      // Re-throw the error if the caller needs to know about the remote failure.
      if (e.type == DioExceptionType.connectionError) {
        throw NetworkFailure(
          message: backendMessage ?? 'Failed to log out remotely. No network.',
        );
      } else if (e.type == DioExceptionType.badResponse &&
          e.response?.statusCode == 401) {
        throw UnauthorizedFailure(
          message:
              backendMessage ?? 'Remote logout failed due to invalid token.',
        );
      }
      throw ServerFailure(
        message: backendMessage ?? 'Failed to log out remotely.',
      );
    } on Exception catch (e) {
      // Catch any other exceptions during logout
      throw UnknownFailure(
        message: 'Logout failed unexpectedly: ${e.toString()}',
      );
    } finally {
      await _authTokenStorageRepository.clearTokens();
    }
  }
}
