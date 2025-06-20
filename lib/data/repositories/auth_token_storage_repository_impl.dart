import 'package:mobile/core/config/app_config.dart';
import 'package:mobile/domain/repositories/auth_token_storage_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenStorageRepositoryImpl extends AuthTokenStorageRepository {
  final SharedPreferencesAsync? _prefs;

  AuthTokenStorageRepositoryImpl(this._prefs);

  @override
  Future<void> clearTokens() async {
    if (_prefs == null) throw Exception('Not initialized');
    await _prefs.remove(AppConfig.accessTokenKey);
    await _prefs.remove(AppConfig.refreshTokenKey);
    await _prefs.remove(AppConfig.deviceIdKey);
  }

  @override
  Future<String?> get accessToken async =>
      await _prefs?.getString(AppConfig.accessTokenKey);
  @override
  Future<String?> get refreshToken async =>
      await _prefs?.getString(AppConfig.refreshTokenKey);
  @override
  Future<String?> get deviceId async =>
      await _prefs?.getString(AppConfig.deviceIdKey);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String deviceId,
  }) async {
    if (_prefs == null) throw Exception('Not initialized');
    await _prefs.setString(AppConfig.accessTokenKey, accessToken);
    await _prefs.setString(AppConfig.refreshTokenKey, refreshToken);
    await _prefs.setString(AppConfig.deviceIdKey, deviceId);
  }
}
