part of 'daily_list_bloc.dart';

sealed class DailyListState extends Equatable {
  const DailyListState();

  @override
  List<Object?> get props => [];
}

final class HabitListInitial extends DailyListState {}

final class DailyListLoading extends DailyListState {}

class HabitListLoaded extends DailyListState {
  final List<HabitEntity> habits;
  final List<DateTime> days;
  final int selectedIndex;

  const HabitListLoaded({
    required this.habits,
    required this.days,
    required this.selectedIndex,
  });

  @override
  List<Object?> get props => [habits, days, selectedIndex];

  HabitListLoaded copyWith({
    List<HabitEntity>? habits,
    List<DateTime>? days,
    int? selectedIndex,
  }) {
    return HabitListLoaded(
      habits: habits ?? this.habits,
      days: days ?? this.days,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class HabitListError extends DailyListState {
  final String message;

  const HabitListError(this.message);

  @override
  List<Object?> get props => [message];
}
