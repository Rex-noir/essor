// data/repositories/authentication_repository_impl.dart
import 'dart:async';

// Your data providers, models, entities, and repository interface
import 'package:mobile/data/datasources/auth_remote_datasource.dart';
import 'package:mobile/domain/entities/auth_response_entity.dart';
import 'package:mobile/domain/enums/authentication_status.dart';
import 'package:mobile/domain/repositories/authentication_repository.dart';

// Import your core and auth-specific failures
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthRemoteDataSource _remoteDataProvider;

  final StreamController<AuthenticationStatus> _controller =
      StreamController<AuthenticationStatus>();

  AuthenticationRepositoryImpl({
    required AuthRemoteDataSource remoteDataProvider,
    required AuthenticationStatus initialStatus,
  }) : _remoteDataProvider = remoteDataProvider {
    _controller.add(initialStatus);
  }

  @override
  Future<AuthResponseEntity> logIn({
    required String email,
    required String password,
  }) async {
    final response = await _remoteDataProvider.logIn(
      email: email,
      password: password,
    );
    _controller.add(AuthenticationStatus.authenticated);

    return response.toEntity();
  }

  @override
  Future<void> logOut({
    required String? refreshToken,
    required String? deviceId,
  }) async {
    _controller.add(AuthenticationStatus.unauthenticated);
    if (refreshToken != null && deviceId != null) {
      await _remoteDataProvider.logOut(
        refreshToken: refreshToken,
        deviceId: deviceId,
      );
    }
  }

  @override
  void dispose() {
    _controller.close();
  }

  @override
  Stream<AuthenticationStatus> get status => _controller.stream;

  @override
  void forceUnauthenticated({
    required String? refreshToken,
    required String? deviceId,
  }) async {
    _controller.add(AuthenticationStatus.unauthenticated);
    if (refreshToken != null && deviceId != null) {
      await _remoteDataProvider.logOut(
        refreshToken: refreshToken,
        deviceId: deviceId,
      );
    }
  }
}
