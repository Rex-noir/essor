import 'package:mobile/domain/models/user_model.dart';

class AutheResponseModel {
  final String accessToken;
  final String refreshToken;
  final String deviceId;
  final UserModel data;

  AutheResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.deviceId,
    required this.data,
  });
}
