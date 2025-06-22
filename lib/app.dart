import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/core/config/app_config.dart';
import 'package:mobile/core/layouts/presentation/layout/home_layout.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/theme/theme.dart';
import 'package:mobile/core/theme/util.dart';
import 'package:mobile/data/datasources/auth_local_datasource.dart';
import 'package:mobile/data/datasources/auth_remote_datasource.dart';
import 'package:mobile/data/repositories/auth_token_storage_repository_impl.dart';
import 'package:mobile/data/repositories/authentication_repository_impl.dart';
import 'package:mobile/data/repositories/habit_repository_impl.dart';
import 'package:mobile/data/repositories/profile_repository_impl.dart';
import 'package:mobile/data/repositories/routine_repository_impl.dart';
import 'package:mobile/data/repositories/task_repository_impl.dart';
import 'package:mobile/database/daos/habits_dao.dart';
import 'package:mobile/database/daos/routines_dao.dart';
import 'package:mobile/database/daos/tasks_dao.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/domain/enums/authentication_status.dart';
import 'package:mobile/domain/repositories/auth_token_storage_repository.dart';
import 'package:mobile/domain/repositories/authentication_repository.dart';
import 'package:mobile/domain/repositories/habit_repository.dart';
import 'package:mobile/domain/repositories/profile_repository.dart';
import 'package:mobile/domain/repositories/routine_repository.dart';
import 'package:mobile/domain/repositories/task_repository.dart';
import 'package:mobile/domain/usecases/get_habits_for_date_usecase.dart';
import 'package:mobile/domain/usecases/get_profile_usecase.dart';
import 'package:mobile/domain/usecases/get_routines_for_date_usecase.dart';
import 'package:mobile/domain/usecases/login_usecase.dart';
import 'package:mobile/domain/usecases/logout_usecase.dart';
import 'package:mobile/ui/authentication/login/login_screen.dart';
import 'package:mobile/ui/authentication/shared/bloc/authentication_bloc.dart';
import 'package:mobile/ui/daily_items/bloc/daily_list_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationStatus? _status;
  bool? _isFirstTime;
  late final AuthLocalDatasource _localAuth;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _localAuth = AuthLocalDatasourceImpl(FlutterSecureStorage());
    final token = await _localAuth.getToken();
    final isFirstTimeStr = await _localAuth.getFlag(AppConfig.isFirstTimeKey);
    final isFirstTime = isFirstTimeStr == null || isFirstTimeStr == "true";

    if (isFirstTime) {
      await _localAuth.setFlag(AppConfig.isFirstTimeKey, "false");
    }

    setState(() {
      _status = token != null
          ? AuthenticationStatus.authenticated
          : AuthenticationStatus.unauthenticated;
      _isFirstTime = isFirstTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_status == null || _isFirstTime == null) {
      return const MaterialApp(home: SplashScreen());
    }

    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final textTheme = createTextTheme(context, "Plus Jakarta Sans", "Inter");
    final theme = MaterialTheme(textTheme);

    final dio = ApiClient().dio;
    final authRepo = AuthenticationRepositoryImpl(
      initialStatus: _status!,
      remoteDataProvider: AuthRemoteDatasource(dio),
    );
    final tokenRepo = AuthTokenStorageRepositoryImpl(SharedPreferencesAsync());

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Dio>(create: (_) => dio),
        RepositoryProvider<AuthLocalDatasource>(create: (_) => _localAuth),
        RepositoryProvider<AuthenticationRepository>(
          create: (_) => authRepo,
          dispose: (repo) => repo.dispose(),
        ),
        RepositoryProvider<AuthTokenStorageRepository>(
          create: (_) => tokenRepo,
        ),
        RepositoryProvider<ProfileRepository>(
          create: (_) => ProfileRepositoryImpl(),
        ),
        RepositoryProvider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (db) => db.close(),
        ),
      ],
      child: Builder(
        builder: (context) => MultiRepositoryProvider(
          providers: [
            RepositoryProvider<TaskRepository>(
              create: (_) =>
                  TaskRepositoryImpl(TasksDao(context.read<AppDatabase>())),
            ),
            RepositoryProvider<RoutineRepository>(
              create: (_) => RoutineRepositoryImpl(
                RoutinesDao(context.read<AppDatabase>()),
              ),
            ),
            RepositoryProvider<HabitRepository>(
              create: (_) => HabitRepositoryImpl(
                habitsDao: HabitsDao(context.read<AppDatabase>()),
              ),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                lazy: false,
                create: (context) => AuthenticationBloc(
                  logInUseCase: LoginUseCase(
                    authTokenStorageRepository: tokenRepo,
                    authenticationRepository: authRepo,
                  ),
                  logOutUseCase: LogoutUseCase(
                    authTokenStorageRepository: context
                        .read<AuthTokenStorageRepository>(),
                    authenticationRepository: context
                        .read<AuthenticationRepository>(),
                  ),
                  getProfileUseCase: GetProfileUseCase(
                    context.read<ProfileRepository>(),
                  ),
                  authenticationStatus: authRepo.status,
                )..add(AuthenticationSubscriptionRequested()),
              ),
              BlocProvider(
                lazy: false,
                create: (context) => DailyListBloc(
                  GetHabitsForDateUsecase(context.read<HabitRepository>()),
                  GetRoutinesForDateUsecase(context.read<RoutineRepository>()),
                )..add(DailyListInitialize()),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'My App',
              theme: brightness == Brightness.light
                  ? theme.light()
                  : theme.dark(),
              home: _isFirstTime! ? const LoginScreen() : const HomeLayout(),
            ),
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
