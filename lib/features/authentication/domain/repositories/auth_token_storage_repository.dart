abstract class AuthTokenStorageRepository {
  String? get accessToken;
  String? get refreshToken;
  String? get deviceId;

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String deviceId,
  });

  Future<void> clearTokens();
}
