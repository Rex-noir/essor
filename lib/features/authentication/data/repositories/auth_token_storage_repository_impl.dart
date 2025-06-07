import 'package:mobile/core/config/app_config.dart';
import 'package:mobile/features/authentication/domain/repositories/auth_token_storage_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenStorageRepositoryImpl extends AuthTokenStorageRepository {
  final AppConfig _config;
  SharedPreferences? _prefs;

  AuthTokenStorageRepositoryImpl(this._config);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> clearTokens() async {
    if (_prefs == null) throw Exception('Not initialized');
    await _prefs!.remove(_config.accessTokenKey);
    await _prefs!.remove(_config.refreshTokenKey);
    await _prefs!.remove(_config.deviceIdKey);
  }

  @override
  String? get accessToken => _prefs?.getString(_config.accessTokenKey);
  @override
  String? get refreshToken => _prefs?.getString(_config.refreshTokenKey);
  @override
  String? get deviceId => _prefs?.getString(_config.deviceIdKey);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String deviceId,
  }) async {
    if (_prefs == null) throw Exception('Not initialized');
    await _prefs!.setString(_config.accessTokenKey, accessToken);
    await _prefs!.setString(_config.refreshTokenKey, refreshToken);
    await _prefs!.setString(_config.deviceIdKey, deviceId);
  }
}
