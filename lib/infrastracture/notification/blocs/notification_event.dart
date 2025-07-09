part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class NotificationStarted extends NotificationEvent {
  @override
  List<Object?> get props => [];
}
