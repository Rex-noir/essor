part of 'habit_list_bloc.dart';

sealed class HabitListEvent extends Equatable {
  const HabitListEvent();

  @override
  List<Object?> get props => [];
}

final class HabitListDateChanged extends HabitListEvent {
  final int newIndex;
  const HabitListDateChanged(this.newIndex);

  @override
  List<Object> get props => [newIndex];
}

class HabitListInitialize extends HabitListEvent {}
