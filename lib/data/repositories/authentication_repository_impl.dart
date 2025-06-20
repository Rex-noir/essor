import 'dart:async';

import 'package:mobile/data/datasources/auth_remote_datasource.dart';
import 'package:mobile/domain/enums/authentication_status.dart';
import 'package:mobile/domain/models/auth_response_entity.dart';
import 'package:mobile/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthRemoteDatasource remoteDataProvider;
  final StreamController<AuthenticationStatus> _controller;
  AuthenticationStatus _currentStatus;

  AuthenticationRepositoryImpl({
    required this.remoteDataProvider,
    required AuthenticationStatus initialStatus,
  }) : _currentStatus = initialStatus,
       _controller = StreamController<AuthenticationStatus>.broadcast();

  @override
  Stream<AuthenticationStatus> get status async* {
    yield _currentStatus;
    yield* _controller.stream;
  }

  @override
  Future<AutheResponseModel> logIn({
    required String email,
    required String password,
  }) async {
    final response = await remoteDataProvider.login(email, password);

    _setStatus(AuthenticationStatus.authenticated);
    return response.toEntity();
  }

  @override
  Future<void> logOut({
    required String? refreshToken,
    required String? deviceId,
  }) async {
    try {
      await remoteDataProvider.logout(refreshToken!, deviceId!);
    } catch (_) {
      // Swallow logout API failures; still clear status locally.
    }
    _setStatus(AuthenticationStatus.unauthenticated);
  }

  @override
  void forceUnauthenticated({
    required String? refreshToken,
    required String? deviceId,
  }) {
    _setStatus(AuthenticationStatus.unauthenticated);
  }

  void _setStatus(AuthenticationStatus newStatus) {
    if (_currentStatus != newStatus) {
      _currentStatus = newStatus;
      _controller.add(newStatus);
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
