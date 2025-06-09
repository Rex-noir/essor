part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  // enum
  final AuthenticationStatus status;
  final UserEntity? user;
  const AuthenticationState(this.status, this.user);

  @override
  List<Object?> get props => [status, user];

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    UserEntity? user,
  }) {
    return AuthenticationState(status ?? this.status, user ?? this.user);
  }

  @override
  bool get stringify => true;
}
