// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'daily_list_bloc.dart';

sealed class DailyListState extends Equatable {
  const DailyListState();

  @override
  List<Object?> get props => [];
}

abstract class DailyItem {}

class HabitItem extends DailyItem {
  final HabitEntity habit;
  HabitItem(this.habit);
}

class RoutineItem extends DailyItem {
  final RoutineEntity routine;
  RoutineItem(this.routine);
}

final class HabitListInitial extends DailyListState {}

final class DailyListLoading extends DailyListState {}

class HabitListLoaded extends DailyListState {
  final List<HabitEntity> habits;
  final List<RoutineEntity> routines;
  final List<DateTime> days;
  final int selectedIndex;

  const HabitListLoaded({
    required this.habits,
    required this.days,
    required this.selectedIndex,
    required this.routines,
  });

  @override
  List<Object?> get props => [habits, days, selectedIndex, routines];

  List<DailyItem> get items {
    return [
      ...habits.map((h) => HabitItem(h)),
      ...routines.map((r) => RoutineItem(r)),
    ];
  }

  HabitListLoaded copyWith({
    List<HabitEntity>? habits,
    List<RoutineEntity>? routines,
    List<DateTime>? days,
    int? selectedIndex,
  }) {
    return HabitListLoaded(
      habits: habits ?? this.habits,
      routines: routines ?? this.routines,
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
