import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/core/config/app_config.dart';

abstract class AuthLocalDatasource {
  Future<void> saveToken(String token);
  Future<void> saveRefreshToken(String refreshToken);

  Future<String?> getToken();
  Future<String?> getRefreshToken();

  Future<void> clearTokens();

  Future<void> setFlag(String key, String value);

  Future<String?> getFlag(String key);
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final FlutterSecureStorage _storage;

  const AuthLocalDatasourceImpl(this._storage);

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConfig.accessTokenKey, value: token);
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: AppConfig.refreshTokenKey, value: refreshToken);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: AppConfig.accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: AppConfig.refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: AppConfig.accessTokenKey);
    await _storage.delete(key: AppConfig.refreshTokenKey);
  }

  @override
  Future<void> setFlag(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> getFlag(String key) async {
    return await _storage.read(key: key);
  }
}
