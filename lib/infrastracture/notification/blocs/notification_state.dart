part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();
}

final class NotificationInitial extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationListening extends NotificationState {
  @override
  List<Object?> get props => [];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
