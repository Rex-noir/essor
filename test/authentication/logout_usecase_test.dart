import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/failures/failures.dart';
import 'package:mobile/features/authentication/domain/repositories/auth_token_storage_repository.dart';
import 'package:mobile/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:mobile/features/authentication/domain/usecases/logout_usecase.dart'; // Adjust path if needed
import 'package:mocktail/mocktail.dart';

// Mock classes using Mocktail
class MockAuthTokenStorageRepository extends Mock
    implements AuthTokenStorageRepository {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late LogoutUseCase logoutUseCase;
  late MockAuthTokenStorageRepository mockAuthTokenStorageRepository;
  late MockAuthenticationRepository mockAuthenticationRepository;

  // Constants for test data
  const String tAccessToken = 'test_access_token';
  const String tDeviceId = 'test_device_id';

  setUp(() {
    // Initialize mocks and the use case before each test
    mockAuthTokenStorageRepository = MockAuthTokenStorageRepository();
    mockAuthenticationRepository = MockAuthenticationRepository();
    logoutUseCase = LogoutUseCase(
      authTokenStorageRepository: mockAuthTokenStorageRepository,
      authenticationRepository: mockAuthenticationRepository,
    );

    // Register fallbacks for `any()` calls if needed, especially for primitives
    // For `accessToken` and `deviceId` from storage, we will mock specific values.
  });

  group('LogoutUseCase', () {
    test('should successfully log out and clear local tokens', () async {
      // Arrange: Set up mock responses for token retrieval and logout
      when(
        () => mockAuthTokenStorageRepository.accessToken,
      ).thenReturn(tAccessToken);
      when(() => mockAuthTokenStorageRepository.deviceId).thenReturn(tDeviceId);
      when(
        () => mockAuthenticationRepository.logOut(
          refreshToken:
              tAccessToken, // Using accessToken for refreshToken in logOut as per your code
          deviceId: tDeviceId,
        ),
      ).thenAnswer((_) async => Future.value());
      when(
        () => mockAuthTokenStorageRepository.clearTokens(),
      ).thenAnswer((_) async => Future.value());

      // Act: Call the use case
      await logoutUseCase();

      // Assert: Verify interactions
      verify(() => mockAuthTokenStorageRepository.accessToken).called(1);
      verify(() => mockAuthTokenStorageRepository.deviceId).called(1);
      verify(
        () => mockAuthenticationRepository.logOut(
          refreshToken: tAccessToken,
          deviceId: tDeviceId,
        ),
      ).called(1);
      verify(() => mockAuthTokenStorageRepository.clearTokens()).called(1);
      verifyNoMoreInteractions(mockAuthenticationRepository);
      verifyNoMoreInteractions(mockAuthTokenStorageRepository);
    });

    group('DioException handling', () {
      // Setup for DioException tests to ensure tokens are always retrieved
      setUp(() {
        when(
          () => mockAuthTokenStorageRepository.accessToken,
        ).thenReturn(tAccessToken);
        when(
          () => mockAuthTokenStorageRepository.deviceId,
        ).thenReturn(tDeviceId);
        when(
          () => mockAuthTokenStorageRepository.clearTokens(),
        ).thenAnswer((_) async => Future.value());
      });

      test(
        'should throw NetworkFailure for connection error but still clear tokens',
        () async {
          // Arrange
          final DioException dioException = DioException(
            requestOptions: RequestOptions(path: '/logout'),
            type: DioExceptionType.connectionError,
            error: 'No Internet',
          );
          when(
            () => mockAuthenticationRepository.logOut(
              refreshToken: any(named: 'refreshToken'),
              deviceId: any(named: 'deviceId'),
            ),
          ).thenThrow(dioException);

          // Act & Assert
          await expectLater(
            () => logoutUseCase(),
            throwsA(
              isA<NetworkFailure>().having(
                (e) => e.message,
                'message',
                'Failed to log out remotely. No network.',
              ),
            ),
          );

          // Verify that local tokens are cleared even on remote failure
          verify(() => mockAuthTokenStorageRepository.accessToken).called(1);
          verify(() => mockAuthTokenStorageRepository.deviceId).called(1);
          verify(
            () => mockAuthenticationRepository.logOut(
              refreshToken: tAccessToken,
              deviceId: tDeviceId,
            ),
          ).called(1);
          verify(() => mockAuthTokenStorageRepository.clearTokens()).called(1);
        },
      );

      test(
        'should throw UnauthorizedFailure for 401 response but still clear tokens',
        () async {
          // Arrange
          final DioException dioException = DioException(
            requestOptions: RequestOptions(path: '/logout'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/logout'),
              statusCode: 401,
              data: {'message': 'Invalid token during logout'},
            ),
          );
          when(
            () => mockAuthenticationRepository.logOut(
              refreshToken: any(named: 'refreshToken'),
              deviceId: any(named: 'deviceId'),
            ),
          ).thenThrow(dioException);

          // Act & Assert
          await expectLater(
            () => logoutUseCase(),
            throwsA(
              isA<UnauthorizedFailure>().having(
                (e) => e.message,
                'message',
                'Invalid token during logout',
              ),
            ),
          );

          // Verify that local tokens are cleared even on remote failure
          verify(() => mockAuthTokenStorageRepository.accessToken).called(1);
          verify(() => mockAuthTokenStorageRepository.deviceId).called(1);
          verify(
            () => mockAuthenticationRepository.logOut(
              refreshToken: tAccessToken,
              deviceId: tDeviceId,
            ),
          ).called(1);
          verify(() => mockAuthTokenStorageRepository.clearTokens()).called(1);
        },
      );

      test(
        'should throw ServerFailure for generic DioException but still clear tokens',
        () async {
          // Arrange
          final DioException dioException = DioException(
            requestOptions: RequestOptions(path: '/logout'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/logout'),
              statusCode: 500,
              data: {'message': 'Backend server error'},
            ),
          );
          when(
            () => mockAuthenticationRepository.logOut(
              refreshToken: any(named: 'refreshToken'),
              deviceId: any(named: 'deviceId'),
            ),
          ).thenThrow(dioException);

          // Act & Assert
          await expectLater(
            () => logoutUseCase(),
            throwsA(
              isA<ServerFailure>().having(
                (e) => e.message,
                'message',
                'Backend server error',
              ),
            ),
          );

          // Verify that local tokens are cleared even on remote failure
          verify(() => mockAuthTokenStorageRepository.accessToken).called(1);
          verify(() => mockAuthTokenStorageRepository.deviceId).called(1);
          verify(
            () => mockAuthenticationRepository.logOut(
              refreshToken: tAccessToken,
              deviceId: tDeviceId,
            ),
          ).called(1);
          verify(() => mockAuthTokenStorageRepository.clearTokens()).called(1);
        },
      );

      test(
        'should throw ServerFailure with default message for generic DioException without backend message',
        () async {
          // Arrange
          final DioException dioException = DioException(
            requestOptions: RequestOptions(path: '/logout'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/logout'),
              statusCode:
                  400, // Example of another bad status code not explicitly handled
              data: {}, // No message from backend
            ),
          );
          when(
            () => mockAuthenticationRepository.logOut(
              refreshToken: any(named: 'refreshToken'),
              deviceId: any(named: 'deviceId'),
            ),
          ).thenThrow(dioException);

          // Act & Assert
          await expectLater(
            () => logoutUseCase(),
            throwsA(
              isA<ServerFailure>().having(
                (e) => e.message,
                'message',
                'Failed to log out remotely.',
              ),
            ),
          );

          // Verify that local tokens are cleared even on remote failure
          verify(() => mockAuthTokenStorageRepository.accessToken).called(1);
          verify(() => mockAuthTokenStorageRepository.deviceId).called(1);
          verify(
            () => mockAuthenticationRepository.logOut(
              refreshToken: tAccessToken,
              deviceId: tDeviceId,
            ),
          ).called(1);
          verify(() => mockAuthTokenStorageRepository.clearTokens()).called(1);
        },
      );
    });

    test(
      'should throw UnknownFailure for generic Exception but still clear tokens',
      () async {
        // Arrange
        final Exception genericException = Exception(
          'Something unexpected happened',
        );
        when(
          () => mockAuthTokenStorageRepository.accessToken,
        ).thenReturn(tAccessToken);
        when(
          () => mockAuthTokenStorageRepository.deviceId,
        ).thenReturn(tDeviceId);
        when(
          () => mockAuthenticationRepository.logOut(
            refreshToken: any(named: 'refreshToken'),
            deviceId: any(named: 'deviceId'),
          ),
        ).thenThrow(genericException);
        when(
          () => mockAuthTokenStorageRepository.clearTokens(),
        ).thenAnswer((_) async => Future.value());

        // Act & Assert
        await expectLater(
          () => logoutUseCase(),
          throwsA(
            isA<UnknownFailure>().having(
              (e) => e.message,
              'message',
              'Logout failed unexpectedly: Exception: Something unexpected happened',
            ),
          ),
        );

        // Verify that local tokens are cleared even on remote failure
        verify(() => mockAuthTokenStorageRepository.accessToken).called(1);
        verify(() => mockAuthTokenStorageRepository.deviceId).called(1);
        verify(
          () => mockAuthenticationRepository.logOut(
            refreshToken: tAccessToken,
            deviceId: tDeviceId,
          ),
        ).called(1);
        verify(() => mockAuthTokenStorageRepository.clearTokens()).called(1);
      },
    );

    test('should clear local tokens even if token retrieval fails', () async {
      // Arrange: Make token retrieval fail
      when(
        () => mockAuthTokenStorageRepository.accessToken,
      ).thenThrow(Exception('Failed to get access token'));
      when(
        () => mockAuthTokenStorageRepository.deviceId,
      ).thenReturn(tDeviceId); // This might still be called
      when(
        () => mockAuthTokenStorageRepository.clearTokens(),
      ).thenAnswer((_) async => Future.value());

      // Act & Assert
      await expectLater(
        () => logoutUseCase(),
        throwsA(
          isA<UnknownFailure>().having(
            (e) => e.message,
            'message',
            contains('Logout failed unexpectedly'),
          ),
        ),
      );

      // Verify that clearTokens is called, even if an early exception occurs
      verify(() => mockAuthTokenStorageRepository.accessToken).called(1);
      verifyNever(
        () => mockAuthenticationRepository.logOut(
          refreshToken: any(named: 'refreshToken'),
          deviceId: any(named: 'deviceId'),
        ),
      ); // Log out won't be called
      verify(() => mockAuthTokenStorageRepository.clearTokens()).called(1);
    });
  });
}
