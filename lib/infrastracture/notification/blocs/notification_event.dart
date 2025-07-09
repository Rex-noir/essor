part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class NotificationStarted extends NotificationEvent {
  @override
  List<Object?> get props => [];
}

final class NotificationForRoutineRequested extends NotificationEvent {
  final RoutineModel routine;

  const NotificationForRoutineRequested(this.routine);

  @override
  List<Object?> get props => [routine];
}
