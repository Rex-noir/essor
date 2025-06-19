import 'package:dio/dio.dart';
import 'package:mobile/core/config/app_config.dart';
import 'package:mobile/data/dtos/auth_response_dto.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);
  Future<AuthResponseDTO> logIn({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      AppConfig.logInEndpoint,
      data: {'email': email, 'password': password},
    );

    final data = AuthResponseDTO.fromMap(response.data);
    return data;
  }

  Future<void> logOut({
    required String refreshToken,
    required String deviceId,
  }) async {
    await _dio.post(
      AppConfig.logOutEndpoint,
      options: Options(
        headers: {"X-Refresh-Token": refreshToken, "Device-ID": deviceId},
      ),
    );
  }
}
