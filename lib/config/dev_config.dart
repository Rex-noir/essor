import 'package:mobile/config/base_config.dart';

class DevConfig implements BaseConfig {
  @override
  String get baseUrl => 'http://127.0.0.1:8080';

  @override
  String get logInEndpoint => '/auth/login';

  @override
  String get logOutEndpoint => '/auth/logout';

  @override
  String get accessTokenKey => 'ACCESS_TOKEN';

  @override
  String get refreshTokenKey => 'REFRESH_TOKEN';

  @override
  String get deviceIdKey => 'DEVICE_ID';

  @override
  String get isFirstTimeKey => 'firstTime';

  @override
  int get taskIconIndex => 0;

  @override
  int get habitIconIndex => 0;

  @override
  int get routineIconIndex => 1;
}
