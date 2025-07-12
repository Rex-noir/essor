// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'daily_list_bloc.dart';

sealed class DailyListState extends Equatable {
  const DailyListState();

  @override
  List<Object?> get props => [];
}

final class DailyListInitial extends DailyListState {}

final class DailyListLoading extends DailyListState {}

class DailyListLoaded extends DailyListState {
  final List<HabitWithEntryModel> habits;
  final List<RoutineWithTaskEntries> routines;
  final List<DateTime> days;
  final int selectedIndex;
  final bool isLoading;

  const DailyListLoaded({
    required this.habits,
    required this.days,
    required this.selectedIndex,
    required this.routines,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [habits, days, selectedIndex, routines];

  List<DailyItemModel> get items {
    return [
      ...habits.map((h) => DailyItemHabitModel(habit: h.habit, entry: h.entry)),
      ...routines.map(
        (r) => DailyItemRoutineModel(routine: r.routine, tasks: r.tasks),
      ),
    ];
  }

  DateTime get selectedDate => days[selectedIndex];

  DailyListLoaded copyWith({
    List<HabitWithEntryModel>? habits,
    List<RoutineWithTaskEntries>? routines,
    List<TaskModel>? tasks,
    List<DateTime>? days,
    int? selectedIndex,
    bool? isLoading,
  }) {
    return DailyListLoaded(
      habits: habits ?? this.habits,
      routines: routines ?? this.routines,
      days: days ?? this.days,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DailyListError extends DailyListState {
  final String message;

  const DailyListError(this.message);

  @override
  List<Object?> get props => [message];
}
