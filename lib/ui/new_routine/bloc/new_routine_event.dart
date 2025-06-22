part of 'new_routine_bloc.dart';

sealed class NewRoutineEvent extends Equatable {
  const NewRoutineEvent();

  @override
  List<Object> get props => [];
}

final class ChangeFrequencyNewRoutineEvent extends NewRoutineEvent {
  final ItemFrequency frequency;
  const ChangeFrequencyNewRoutineEvent(this.frequency);

  @override
  List<Object> get props => [frequency];
}

final class UpdateIntervalNewRoutineEvent extends NewRoutineEvent {
  final int interval;
  const UpdateIntervalNewRoutineEvent(this.interval);

  @override
  List<Object> get props => [interval];
}

final class UpdateWeeklyDaysNewRoutineEvent extends NewRoutineEvent {
  final List<int> weeklyDays;
  const UpdateWeeklyDaysNewRoutineEvent(this.weeklyDays);

  @override
  List<Object> get props => [weeklyDays];
}

final class UpdateMonthlyDatesNewRoutineEvent extends NewRoutineEvent {
  final List<int> monthlyDates;
  const UpdateMonthlyDatesNewRoutineEvent(this.monthlyDates);

  @override
  List<Object> get props => [monthlyDates];
}

final class UpdateStartDateNewRoutineEvent extends NewRoutineEvent {
  final DateTime startDate;
  const UpdateStartDateNewRoutineEvent(this.startDate);

  @override
  List<Object> get props => [startDate];
}

final class UpdateStartTimeNewRoutineEvent extends NewRoutineEvent {
  final TimeOfDay startTime;
  const UpdateStartTimeNewRoutineEvent(this.startTime);

  @override
  List<Object> get props => [startTime];
}

final class NewRoutineTitleChanged extends NewRoutineEvent {
  final String title;
  const NewRoutineTitleChanged(this.title);
}

final class NewRoutineIconChanged extends NewRoutineEvent {
  final int iconIndex;
  const NewRoutineIconChanged(this.iconIndex);
}

final class CreateRoutineRequested extends NewRoutineEvent {
  final DailyListBloc dailyListBloc;
  final Function(RoutineModel, DateTime) navigateToViewRoutine;

  const CreateRoutineRequested({
    required this.dailyListBloc,
    required this.navigateToViewRoutine,
  });

  @override
  List<Object> get props => [dailyListBloc, navigateToViewRoutine];
}

final class NewRoutineSubmitted extends NewRoutineEvent {}
