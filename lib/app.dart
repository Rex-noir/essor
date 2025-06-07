import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/config/app_config.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/theme/theme.dart';
import 'package:mobile/core/theme/util.dart';
import 'package:mobile/features/authentication/data/providers/auth_remote_data_provider.dart';
import 'package:mobile/features/authentication/data/repositories/auth_token_storage_repository_impl.dart';
import 'package:mobile/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:mobile/features/authentication/domain/enums/authentication_status.dart';
import 'package:mobile/features/authentication/domain/repositories/auth_token_storage_repository.dart';
import 'package:mobile/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:mobile/features/authentication/domain/usecases/login_usecase.dart';
import 'package:mobile/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:mobile/features/authentication/presentation/login/login_screen.dart';
import 'package:mobile/features/authentication/presentation/shared/bloc/authentication_bloc.dart';
import 'package:mobile/features/layouts/presentation/layout/home_layout.dart';
import 'package:mobile/features/profile/data/providers/profile_data_local_provider.dart';
import 'package:mobile/features/profile/data/providers/profile_data_provider.dart';
import 'package:mobile/features/profile/data/repositories/profile_respository_impl.dart';
import 'package:mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:mobile/features/profile/domain/usecases/get_profile_usecase.dart';

class App extends StatelessWidget {
  final AuthenticationStatus initialStatus;
  final AppConfig appConfig;
  final bool isFirstTime;
  const App({
    required this.initialStatus,
    required this.appConfig,
    required this.isFirstTime,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(
      context,
      "Roboto Condensed",
      "Work Sans",
    );
    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Dio>(create: (context) => ApiClient().dio),
        RepositoryProvider(
          create: (context) {
            final dio = context.read<Dio>();
            return AuthRemoteDataProvider(dio, config: appConfig);
          },
        ),
        RepositoryProvider<AuthTokenStorageRepository>(
          create: (context) => AuthTokenStorageRepositoryImpl(appConfig),
        ),
        RepositoryProvider<AuthenticationRepository>(
          create: (context) {
            final provider = context.read<AuthRemoteDataProvider>();
            return AuthenticationRepositoryImpl(
              remoteDataProvider: provider,
              initialStatus: initialStatus,
            );
          },
          dispose: (value) => value.dispose(),
        ),
        RepositoryProvider<ProfileDataProvider>(
          create: (context) => ProfileDataLocalProvider(),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRespositoryImpl(
            provider: context.read<ProfileDataProvider>(),
          ),
        ),
      ],
      child: BlocProvider(
        lazy: false,
        create: (context) {
          final authenticationRepository = context
              .read<AuthenticationRepository>();
          final authTokenStorageRepository = context
              .read<AuthTokenStorageRepository>();
          final profilerepo = context.read<ProfileRepository>();
          return AuthenticationBloc(
            logInUseCase: LoginUseCase(
              authTokenStorageRepository: authTokenStorageRepository,
              authenticationRepository: authenticationRepository,
            ),
            logOutUseCase: LogoutUseCase(
              authTokenStorageRepository: authTokenStorageRepository,
              authenticationRepository: authenticationRepository,
            ),
            getProfileUseCase: GetProfileUseCase(profilerepo),
            authenticationStatus: authenticationRepository.status,
          )..add(AuthenticationSubscriptionRequested());
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My App',
          theme: brightness == Brightness.light ? theme.light() : theme.dark(),
          home: isFirstTime ? const LoginScreen() : const HomeLayout(),
        ),
      ),
    );
  }
}
