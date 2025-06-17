part of 'new_routine_bloc.dart';

sealed class NewRoutineEvent extends Equatable {
  const NewRoutineEvent();

  @override
  List<Object> get props => [];
}

class ChangeFrequencyNewRoutineEvent extends NewRoutineEvent {
  final ItemFrequency frequency;
  const ChangeFrequencyNewRoutineEvent(this.frequency);

  @override
  List<Object> get props => [frequency];
}

class UpdateIntervalNewRoutineEvent extends NewRoutineEvent {
  final int interval;
  const UpdateIntervalNewRoutineEvent(this.interval);

  @override
  List<Object> get props => [interval];
}

class UpdateWeeklyDaysNewRoutineEvent extends NewRoutineEvent {
  final List<int> weeklyDays;
  const UpdateWeeklyDaysNewRoutineEvent(this.weeklyDays);

  @override
  List<Object> get props => [weeklyDays];
}

class UpdateMonthlyDatesNewRoutineEvent extends NewRoutineEvent {
  final List<int> monthlyDates;
  const UpdateMonthlyDatesNewRoutineEvent(this.monthlyDates);

  @override
  List<Object> get props => [monthlyDates];
}

class UpdateStartDateNewRoutineEvent extends NewRoutineEvent {
  final DateTime startDate;
  const UpdateStartDateNewRoutineEvent(this.startDate);

  @override
  List<Object> get props => [startDate];
}

class UpdateStartTimeNewRoutineEvent extends NewRoutineEvent {
  final TimeOfDay startTime;
  const UpdateStartTimeNewRoutineEvent(this.startTime);

  @override
  List<Object> get props => [startTime];
}
