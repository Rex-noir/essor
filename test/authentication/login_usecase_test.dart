import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/entities/auth_response_entity.dart';
import 'package:mobile/domain/entities/user_entity.dart';
import 'package:mobile/domain/failures/auth_failures.dart';
import 'package:mobile/domain/failures/failures.dart';
import 'package:mobile/domain/repositories/auth_token_storage_repository.dart';
import 'package:mobile/domain/repositories/authentication_repository.dart';
import 'package:mobile/domain/usecases/login_usecase.dart'; // Adjust path if needed
import 'package:mocktail/mocktail.dart';

// Mock classes using Mocktail
class MockAuthTokenStorageRepository extends Mock
    implements AuthTokenStorageRepository {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthTokenStorageRepository mockAuthTokenStorageRepository;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthTokenStorageRepository = MockAuthTokenStorageRepository();
    mockAuthenticationRepository = MockAuthenticationRepository();
    loginUseCase = LoginUseCase(
      authTokenStorageRepository: mockAuthTokenStorageRepository,
      authenticationRepository: mockAuthenticationRepository,
    );
  });

  const String tEmail = 'test@example.com';
  const String tPassword = 'password123';
  final UserEntity tUserEntity = UserEntity(
    id: '1',
    email: tEmail,
    name: "name",
  );
  final AuthResponseEntity tLoginResponseEntity = AuthResponseEntity(
    accessToken: 'some_access_token',
    refreshToken: 'some_refresh_token',
    deviceId: 'some_device_id',
    data: tUserEntity,
  );

  group('LoginUseCase', () {
    test('should successfully log in and save tokens', () async {
      // Arrange
      when(
        () => mockAuthenticationRepository.logIn(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => tLoginResponseEntity);

      when(
        () => mockAuthTokenStorageRepository.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
          deviceId: any(named: 'deviceId'),
        ),
      ).thenAnswer((_) async => Future.value()); // Mock successful save

      // Act
      final result = await loginUseCase.logIn(
        email: tEmail,
        password: tPassword,
      );

      // Assert
      expect(result, tUserEntity);
      verify(
        () => mockAuthenticationRepository.logIn(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verify(
        () => mockAuthTokenStorageRepository.saveTokens(
          accessToken: tLoginResponseEntity.accessToken,
          refreshToken: tLoginResponseEntity.refreshToken,
          deviceId: tLoginResponseEntity.deviceId,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAuthenticationRepository);
      verifyNoMoreInteractions(mockAuthTokenStorageRepository);
    });

    group('DioException handling', () {
      test(
        'should throw NetworkFailure for DioExceptionType.connectionError',
        () async {
          // Arrange
          final DioException dioException = DioException(
            requestOptions: RequestOptions(path: '/login'),
            type: DioExceptionType.connectionError,
            error: 'No Internet',
          );
          when(
            () => mockAuthenticationRepository.logIn(
              email: tEmail,
              password: tPassword,
            ),
          ).thenThrow(dioException);

          // Act & Assert
          expect(
            () => loginUseCase.logIn(email: tEmail, password: tPassword),
            throwsA(
              isA<NetworkFailure>().having(
                (e) => e.message,
                'message',
                'No internet connection. Please check your network.',
              ),
            ),
          );
          verify(
            () => mockAuthenticationRepository.logIn(
              email: tEmail,
              password: tPassword,
            ),
          ).called(1);
          verifyZeroInteractions(mockAuthTokenStorageRepository);
        },
      );

      test(
        'should throw NetworkFailure for DioExceptionType.sendTimeout',
        () async {
          // Arrange
          final DioException dioException = DioException(
            requestOptions: RequestOptions(path: '/login'),
            type: DioExceptionType.sendTimeout,
            error: 'Timeout',
          );
          when(
            () => mockAuthenticationRepository.logIn(
              email: tEmail,
              password: tPassword,
            ),
          ).thenThrow(dioException);

          // Act & Assert
          expect(
            () => loginUseCase.logIn(email: tEmail, password: tPassword),
            throwsA(
              isA<NetworkFailure>().having(
                (e) => e.message,
                'message',
                'No internet connection. Please check your network.',
              ),
            ),
          );
        },
      );

      test('should throw InvalidCredentialsFailure for 401', () async {
        // Arrange
        final DioException dioException = DioException(
          requestOptions: RequestOptions(path: '/login'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/login'),
            statusCode: 401,
            data: {'message': 'Invalid credentials provided'},
          ),
        );
        when(
          () => mockAuthenticationRepository.logIn(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(dioException);

        // Act & Assert
        expect(
          () => loginUseCase.logIn(email: tEmail, password: tPassword),
          throwsA(
            isA<InvalidCredentialsFailure>().having(
              (e) => e.message,
              'message',
              'Invalid credentials provided',
            ),
          ),
        );
      });

      test(
        'should throw InvalidCredentialsFailure for 401 with default message',
        () async {
          // Arrange
          final DioException dioException = DioException(
            requestOptions: RequestOptions(path: '/login'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/login'),
              statusCode: 401,
              data: {}, // No message from backend
            ),
          );
          when(
            () => mockAuthenticationRepository.logIn(
              email: tEmail,
              password: tPassword,
            ),
          ).thenThrow(dioException);

          // Act & Assert
          expect(
            () => loginUseCase.logIn(email: tEmail, password: tPassword),
            throwsA(
              isA<InvalidCredentialsFailure>().having(
                (e) => e.message,
                'message',
                'Invalid email or password.',
              ),
            ),
          );
        },
      );

      test('should throw UserDisabledFailure for 403', () async {
        // Arrange
        final DioException dioException = DioException(
          requestOptions: RequestOptions(path: '/login'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/login'),
            statusCode: 403,
            data: {'message': 'Account is inactive'},
          ),
        );
        when(
          () => mockAuthenticationRepository.logIn(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(dioException);

        // Act & Assert
        expect(
          () => loginUseCase.logIn(email: tEmail, password: tPassword),
          throwsA(
            isA<UserDisabledFailure>().having(
              (e) => e.message,
              'message',
              'Account is inactive',
            ),
          ),
        );
      });

      test('should throw UserNotFoundFailure for 404', () async {
        // Arrange
        final DioException dioException = DioException(
          requestOptions: RequestOptions(path: '/login'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/login'),
            statusCode: 404,
            data: {'message': 'User not found for this email'},
          ),
        );
        when(
          () => mockAuthenticationRepository.logIn(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(dioException);

        // Act & Assert
        expect(
          () => loginUseCase.logIn(email: tEmail, password: tPassword),
          throwsA(
            isA<UserNotFoundFailure>().having(
              (e) => e.message,
              'message',
              'User not found for this email',
            ),
          ),
        );
      });

      test('should throw EmailAlreadyInUseFailure for 409', () async {
        // Arrange
        final DioException dioException = DioException(
          requestOptions: RequestOptions(path: '/login'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/login'),
            statusCode: 409,
            data: {'message': 'Email already registered'},
          ),
        );
        when(
          () => mockAuthenticationRepository.logIn(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(dioException);

        // Act & Assert
        expect(
          () => loginUseCase.logIn(email: tEmail, password: tPassword),
          throwsA(
            isA<EmailAlreadyInUseFailure>().having(
              (e) => e.message,
              'message',
              'Email already registered',
            ),
          ),
        );
      });

      test('should throw ServerFailure for 500', () async {
        // Arrange
        final DioException dioException = DioException(
          requestOptions: RequestOptions(path: '/login'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/login'),
            statusCode: 500,
            data: {'message': 'Internal server error'},
          ),
        );
        when(
          () => mockAuthenticationRepository.logIn(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(dioException);

        // Act & Assert
        expect(
          () => loginUseCase.logIn(email: tEmail, password: tPassword),
          throwsA(
            isA<ServerFailure>()
                .having((e) => e.message, 'message', 'Internal server error')
                .having((e) => e.code, 'code', '500'),
          ),
        );
      });

      test('should throw ServerFailure for other 5xx codes', () async {
        // Arrange
        final DioException dioException = DioException(
          requestOptions: RequestOptions(path: '/login'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/login'),
            statusCode: 503,
            data: {'message': 'Service Unavailable'},
          ),
        );
        when(
          () => mockAuthenticationRepository.logIn(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(dioException);

        // Act & Assert
        expect(
          () => loginUseCase.logIn(email: tEmail, password: tPassword),
          throwsA(
            isA<ServerFailure>()
                .having((e) => e.message, 'message', 'Service Unavailable')
                .having((e) => e.code, 'code', '503'),
          ),
        );
      });

      test(
        'should throw ServerFailure for generic bad response with unknown status code',
        () async {
          // Arrange
          final DioException dioException = DioException(
            requestOptions: RequestOptions(path: '/login'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/login'),
              statusCode: 418, // I'm a teapot
              data: {'message': 'Unknown API error'},
            ),
          );
          when(
            () => mockAuthenticationRepository.logIn(
              email: tEmail,
              password: tPassword,
            ),
          ).thenThrow(dioException);

          // Act & Assert
          expect(
            () => loginUseCase.logIn(email: tEmail, password: tPassword),
            throwsA(
              isA<ServerFailure>()
                  .having((e) => e.message, 'message', 'Unknown API error')
                  .having((e) => e.code, 'code', '418'),
            ),
          );
        },
      );

      test(
        'should throw UnknownFailure for other DioException types',
        () async {
          // Arrange
          final DioException dioException = DioException(
            requestOptions: RequestOptions(path: '/login'),
            type: DioExceptionType.cancel,
            error: 'Request cancelled',
          );
          when(
            () => mockAuthenticationRepository.logIn(
              email: tEmail,
              password: tPassword,
            ),
          ).thenThrow(dioException);

          // Act & Assert
          expect(
            () => loginUseCase.logIn(email: tEmail, password: tPassword),
            throwsA(
              isA<UnknownFailure>().having(
                (e) => e.message,
                'message',
                contains('An unexpected error occurred:'),
              ),
            ),
          );
        },
      );
    });

    test('should throw UnknownFailure for generic Exception', () async {
      // Arrange
      final Exception genericException = Exception('Something went wrong');
      when(
        () => mockAuthenticationRepository.logIn(
          email: tEmail,
          password: tPassword,
        ),
      ).thenThrow(genericException);

      // Act & Assert
      expect(
        () => loginUseCase.logIn(email: tEmail, password: tPassword),
        throwsA(
          isA<UnknownFailure>().having(
            (e) => e.message,
            'message',
            contains(
              'An unforeseen application error occurred: Exception: Something went wrong',
            ),
          ),
        ),
      );
    });
  });
}
