import 'package:mobile/core/config/app_config.dart';

class DevConfig implements AppConfig {
  @override
  String get baseUrl => 'http://127.0.01:8080';

  @override
  String get logInEndpoint => '/auth/login';

  @override
  String get logOutEndpoint => '/auth/logout';

  @override
  String get accessTokenKey => 'ACCESS_TOKEN';

  @override
  String get refreshTokenKey => 'REFRESH_TOKEN';

  @override
  String get deviceIdkey => 'DEVICE_ID';

  @override
  String get isFirstTimeKey => 'firstTime';
}
