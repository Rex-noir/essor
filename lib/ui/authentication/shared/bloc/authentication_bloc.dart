// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/domain/entities/user_entity.dart';
import 'package:mobile/domain/failures/failures.dart';
import 'package:mobile/domain/enums/authentication_status.dart';
import 'package:mobile/domain/usecases/get_profile_usecase.dart';
import 'package:mobile/domain/usecases/login_usecase.dart';
import 'package:mobile/domain/usecases/logout_usecase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LogoutUseCase _logoutUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final Stream<AuthenticationStatus> _authenticationStatus;
  AuthenticationBloc({
    required LoginUseCase logInUseCase,
    required LogoutUseCase logOutUseCase,
    required GetProfileUseCase getProfileUseCase,
    required Stream<AuthenticationStatus> authenticationStatus,
  }) : _logoutUseCase = logOutUseCase,
       _authenticationStatus = authenticationStatus,
       _getProfileUseCase = getProfileUseCase,
       super(AuthenticationState(AuthenticationStatus.unauthenticated, null)) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    return emit.onEach(
      _authenticationStatus,
      onData: (status) async {
        switch (status) {
          case AuthenticationStatus.authenticated:
            try {
              final user = await _getProfileUseCase.call();
              return emit(
                state.copyWith(
                  status: AuthenticationStatus.authenticated,
                  user: user,
                ),
              );
            } on NetworkFailure {
              return emit(
                state.copyWith(status: AuthenticationStatus.authenticated),
              );
            } catch (e) {
              _logoutUseCase.call();
            }
          case AuthenticationStatus.unauthenticated:
            return emit(
              state.copyWith(status: AuthenticationStatus.unauthenticated),
            );
        }
      },
      onError: onError,
    );
  }

  FutureOr<void> _onLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _logoutUseCase.call();
  }
}
