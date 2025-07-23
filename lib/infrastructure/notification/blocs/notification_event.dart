part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class NotificationStarted extends NotificationEvent {
  @override
  List<Object?> get props => [];
}

final class NotificationScheduleForRoutineRequested extends NotificationEvent {
  final RoutineModel model;

  const NotificationScheduleForRoutineRequested(this.model);

  @override
  List<Object?> get props => [model];
}

final class NotificationScheduleForHabitRequested extends NotificationEvent {
  final HabitModel model;

  const NotificationScheduleForHabitRequested(this.model);

  @override
  List<Object?> get props => [model];
}

final class NotificationScheduleCancelRequestedForModel
    extends NotificationEvent {
  final Schedulable model;

  const NotificationScheduleCancelRequestedForModel(this.model);

  @override
  List<Object?> get props => [model];
}
