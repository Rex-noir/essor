abstract class AuthTokenStorageRepository {
  Future<String?> get accessToken;
  Future<String?> get refreshToken;
  Future<String?> get deviceId;

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String deviceId,
  });

  Future<void> clearTokens();
}
