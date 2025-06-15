import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/data/datasources/auth_remote_datasource.dart';
import 'package:mobile/data/datasources/profile_local_datasource.dart';
import 'package:mobile/data/repositories/auth_token_storage_repository_impl.dart';
import 'package:mobile/data/repositories/authentication_repository_impl.dart';
import 'package:mobile/data/repositories/profile_respository_impl.dart';
import 'package:mobile/domain/datasources/profile_datasource.dart';
import 'package:mobile/domain/enums/authentication_status.dart';
import 'package:mobile/domain/repositories/auth_token_storage_repository.dart';
import 'package:mobile/domain/repositories/authentication_repository.dart';
import 'package:mobile/domain/repositories/profile_repository.dart';
import 'package:mobile/domain/usecases/get_profile_usecase.dart';
import 'package:mobile/domain/usecases/login_usecase.dart';
import 'package:mobile/domain/usecases/logout_usecase.dart';
import 'package:mobile/network/api_client.dart';
import 'package:mobile/ui/authentication/login/login_screen.dart';
import 'package:mobile/ui/authentication/shared/bloc/authentication_bloc.dart';
import 'package:mobile/ui/core/layouts/presentation/layout/home_layout.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:mobile/ui/core/theme/util.dart';

class App extends StatelessWidget {
  final AuthenticationStatus initialStatus;
  final bool isFirstTime;
  const App({
    required this.initialStatus,
    required this.isFirstTime,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(
      context,
      "Plus Jakarta Sans", // Headlines
      "Inter", // Body
    );

    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Dio>(create: (context) => ApiClient().dio),
        RepositoryProvider(
          create: (context) {
            final dio = context.read<Dio>();
            return AuthRemoteDataSource(dio);
          },
        ),
        RepositoryProvider<AuthTokenStorageRepository>(
          create: (context) => AuthTokenStorageRepositoryImpl(),
        ),
        RepositoryProvider<AuthenticationRepository>(
          create: (context) {
            final provider = context.read<AuthRemoteDataSource>();
            return AuthenticationRepositoryImpl(
              remoteDataProvider: provider,
              initialStatus: initialStatus,
            );
          },
          dispose: (value) => value.dispose(),
        ),
        RepositoryProvider<ProfileDataSource>(
          create: (context) => ProfileLocalDataSource(),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRespositoryImpl(
            provider: context.read<ProfileDataSource>(),
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
