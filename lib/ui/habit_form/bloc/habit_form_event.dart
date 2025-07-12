part of 'habit_form_bloc.dart';

sealed class HabitFormEvent extends Equatable {
  const HabitFormEvent();

  @override
  List<Object?> get props => [];
}

final class HabitFormInitial extends HabitFormEvent {
  final HabitModel? habit;
  final DateTime? startDate;

  const HabitFormInitial(this.habit, this.startDate);

  @override
  List<Object?> get props => [habit, startDate];
}

final class HabitFormTitleUpdated extends HabitFormEvent {
  final String title;

  const HabitFormTitleUpdated(this.title);

  @override
  List<Object?> get props => [title];
}

final class HabitFormDescriptionUpdated extends HabitFormEvent {
  final String? description;

  const HabitFormDescriptionUpdated(this.description);

  @override
  List<Object?> get props => [description];
}

final class HabitFormIconIndexUpdated extends HabitFormEvent {
  final int iconIndex;

  const HabitFormIconIndexUpdated(this.iconIndex);

  @override
  List<Object?> get props => [iconIndex];
}

final class HabitFormFrequencyUpdated extends HabitFormEvent {
  final ItemFrequency frequency;

  const HabitFormFrequencyUpdated(this.frequency);

  @override
  List<Object?> get props => [frequency];
}

final class HabitFormStartDateUpdated extends HabitFormEvent {
  final DateTime startDate;

  const HabitFormStartDateUpdated(this.startDate);

  @override
  List<Object?> get props => [startDate];
}

final class HabitFormWeeklyDaysUpdated extends HabitFormEvent {
  final List<int> weeklyDays;

  const HabitFormWeeklyDaysUpdated(this.weeklyDays);

  @override
  List<Object?> get props => [weeklyDays];
}

final class HabitFormMonthlyDatesUpdated extends HabitFormEvent {
  final List<int> monthlyDates;

  const HabitFormMonthlyDatesUpdated(this.monthlyDates);

  @override
  List<Object?> get props => [monthlyDates];
}

final class HabitFormIntervalUpdated extends HabitFormEvent {
  final int interval;

  const HabitFormIntervalUpdated(this.interval);

  @override
  List<Object?> get props => [interval];
}

final class HabitFormIsActiveToggled extends HabitFormEvent {
  final bool isActive;

  const HabitFormIsActiveToggled(this.isActive);

  @override
  List<Object?> get props => [isActive];
}

final class HabitFormTypeUpdated extends HabitFormEvent {
  final ItemType habitType;

  const HabitFormTypeUpdated(this.habitType);

  @override
  List<Object?> get props => [habitType];
}

final class HabitFormTargetUnitUpdated extends HabitFormEvent {
  final String? targetUnit;

  const HabitFormTargetUnitUpdated(this.targetUnit);

  @override
  List<Object?> get props => [targetUnit];
}

final class HabitFormTargetValueUpdated extends HabitFormEvent {
  final int? targetValue;

  const HabitFormTargetValueUpdated(this.targetValue);

  @override
  List<Object?> get props => [targetValue];
}

final class HabitFormTargetOperatorUpdated extends HabitFormEvent {
  final TargetOperator targetOperator;

  const HabitFormTargetOperatorUpdated(this.targetOperator);

  @override
  List<Object?> get props => [targetOperator];
}

final class HabitFormStartTimeUpdated extends HabitFormEvent {
  final TimeOfDay time;

  const HabitFormStartTimeUpdated(this.time);

  @override
  List<Object?> get props => [time];
}

final class HabitFormSubmitted extends HabitFormEvent {
  final HabitModel habit;

  const HabitFormSubmitted(this.habit);

  @override
  List<Object?> get props => [habit];
}
