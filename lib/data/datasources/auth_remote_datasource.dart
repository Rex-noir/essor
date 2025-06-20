import 'package:dio/dio.dart';
import 'package:mobile/core/config/app_config.dart';
import 'package:mobile/data/dto/auth_response_dto.dart';

class AuthRemoteDatasource {
  final Dio dio;

  const AuthRemoteDatasource(this.dio);

  Future<AuthResponseDto> login(String email, String password) async {
    final response = await dio.post(
      AppConfig.logInEndpoint,
      data: {'email': email, 'password': password},
    );
    return AuthResponseDto.fromJson(response.data);
  }

  Future<void> logout(String refreshToken, String deviceId) async {
    await dio.post(AppConfig.logOutEndpoint);
  }
}
