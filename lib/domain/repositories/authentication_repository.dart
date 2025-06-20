import 'package:mobile/domain/enums/authentication_status.dart';
import 'package:mobile/domain/models/auth_response_entity.dart';

abstract class AuthenticationRepository {
  Future<AutheResponseModel> logIn({
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
