import 'package:mobile/config/app_config.dart';
import 'package:mobile/domain/repositories/auth_token_storage_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenStorageRepositoryImpl extends AuthTokenStorageRepository {
  SharedPreferences? _prefs;

  AuthTokenStorageRepositoryImpl();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> clearTokens() async {
    if (_prefs == null) throw Exception('Not initialized');
    await _prefs!.remove(AppConfig.accessTokenKey);
    await _prefs!.remove(AppConfig.refreshTokenKey);
    await _prefs!.remove(AppConfig.deviceIdKey);
  }

  @override
  String? get accessToken => _prefs?.getString(AppConfig.accessTokenKey);
  @override
  String? get refreshToken => _prefs?.getString(AppConfig.refreshTokenKey);
  @override
  String? get deviceId => _prefs?.getString(AppConfig.deviceIdKey);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String deviceId,
  }) async {
    if (_prefs == null) throw Exception('Not initialized');
    await _prefs!.setString(AppConfig.accessTokenKey, accessToken);
    await _prefs!.setString(AppConfig.refreshTokenKey, refreshToken);
    await _prefs!.setString(AppConfig.deviceIdKey, deviceId);
  }
}
