abstract class BaseConfig {
  String get baseUrl;
  String get logInEndpoint;
  String get logOutEndpoint;

  String get accessTokenKey;
  String get refreshTokenKey;
  String get deviceIdKey;

  String get isFirstTimeKey;

  int get taskIconIndex;
  int get habitIconIndex;
  int get routineIconIndex;
}
