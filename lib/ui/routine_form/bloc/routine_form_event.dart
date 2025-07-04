part of 'routine_form_bloc.dart';

sealed class RoutineFormEvent extends Equatable {
  const RoutineFormEvent();

  @override
  List<Object?> get props => [];
}

final class RoutineFormInitial extends RoutineFormEvent {
  final RoutineModel? existingModel;
  final DateTime? startDate;

  const RoutineFormInitial({
    required this.existingModel,
    required this.startDate,
  });

  @override
  List<Object?> get props => [existingModel, startDate];
}

final class RoutineFormFrequencyUpated extends RoutineFormEvent {
  final ItemFrequency frequency;

  const RoutineFormFrequencyUpated(this.frequency);

  @override
  List<Object> get props => [frequency];
}

final class RoutineFormIntervalUpdated extends RoutineFormEvent {
  final int interval;

  const RoutineFormIntervalUpdated(this.interval);

  @override
  List<Object> get props => [interval];
}

final class RoutineFormWeeklyDaysUpdated extends RoutineFormEvent {
  final List<int> weeklyDays;

  const RoutineFormWeeklyDaysUpdated(this.weeklyDays);

  @override
  List<Object> get props => [weeklyDays];
}

final class RoutineFormMonthlyDatesUpdated extends RoutineFormEvent {
  final List<int> monthlyDates;

  const RoutineFormMonthlyDatesUpdated(this.monthlyDates);

  @override
  List<Object> get props => [monthlyDates];
}

final class RoutineFormStartDateUpdated extends RoutineFormEvent {
  final DateTime startDate;

  const RoutineFormStartDateUpdated(this.startDate);

  @override
  List<Object> get props => [startDate];
}

final class RoutineFormStartTimeUpdated extends RoutineFormEvent {
  final TimeOfDay startTime;

  const RoutineFormStartTimeUpdated(this.startTime);

  @override
  List<Object> get props => [startTime];
}

final class RoutineFormTitileUpdated extends RoutineFormEvent {
  final String title;

  const RoutineFormTitileUpdated(this.title);
}

final class RoutineFormIconUpdated extends RoutineFormEvent {
  final int iconIndex;

  const RoutineFormIconUpdated(this.iconIndex);
}

final class RoutineFormSubmitRequested extends RoutineFormEvent {
  final Function({required RoutineModel routine, required RoutineFormMode mode})
  onSubmit;

  const RoutineFormSubmitRequested({required this.onSubmit});

  @override
  List<Object> get props => [onSubmit];
}

final class NewRoutineSubmitted extends RoutineFormEvent {}
