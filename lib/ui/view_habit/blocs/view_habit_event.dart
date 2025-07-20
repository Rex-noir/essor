part of 'view_habit_bloc.dart';

sealed class ViewHabitEvent extends Equatable {
  const ViewHabitEvent();

  @override
  List<Object?> get props => [];
}

final class ViewHabitStarted extends ViewHabitEvent {
  final ViewHabitModel model;
  final DateTime date;

  const ViewHabitStarted(this.model, this.date);

  @override
  List<Object?> get props => [model, date];
}

final class ViewHabitEntryUpdated extends ViewHabitEvent {
  final HabitEntryModel entry;

  const ViewHabitEntryUpdated(this.entry);

  @override
  List<Object?> get props => [entry];
}
