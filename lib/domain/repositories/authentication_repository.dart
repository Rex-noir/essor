import 'package:mobile/domain/entities/auth_response_entity.dart';
import 'package:mobile/domain/enums/authentication_status.dart';

abstract class AuthenticationRepository {
  Future<AuthResponseEntity> logIn({
    required String email,
    required String password,
  });
  Future<void> logOut({
    required String? refreshToken,
    required String? deviceId,
  });
  Stream<AuthenticationStatus> get status;
  void forceUnauthenticated({
    required String? refreshToken,
    required String? deviceId,
  });
  void dispose();
}
