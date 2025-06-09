import 'package:mobile/domain/entities/user_entity.dart';

class AuthResponseEntity {
  final String accessToken;
  final String refreshToken;
  final String deviceId;
  final UserEntity data;

  AuthResponseEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.deviceId,
    required this.data,
  });
}
