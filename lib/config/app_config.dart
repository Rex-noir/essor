import 'package:mobile/config/base_config.dart';
import 'package:mobile/config/dev_config.dart';

class AppConfig {
  static final BaseConfig _config =
      DevConfig(); // Easily switch to ProdConfig later

  static String get baseUrl => _config.baseUrl;
  static String get logInEndpoint => _config.logInEndpoint;
  static String get logOutEndpoint => _config.logOutEndpoint;

  static String get accessTokenKey => _config.accessTokenKey;
  static String get refreshTokenKey => _config.refreshTokenKey;
  static String get deviceIdKey => _config.deviceIdKey;

  static String get isFirstTimeKey => _config.isFirstTimeKey;

  static int get taskIconIndex => _config.taskIconIndex;
  static int get habitIconIndex => _config.habitIconIndex;
  static int get routineIconIndex => _config.routineIconIndex;
}
