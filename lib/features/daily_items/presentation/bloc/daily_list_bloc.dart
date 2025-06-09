import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/core/utils/app_logger.dart';
import 'package:mobile/core/domain/entities/habit_entity.dart';
import 'package:mobile/core/domain/entities/routine_enitity.dart';
import 'package:mobile/core/domain/entities/task_entity.dart';
import 'package:mobile/core/domain/usecases/get_habits_for_date_usecase.dart';
import 'package:mobile/core/domain/usecases/get_routines_for_date_usecase.dart';
import 'package:mobile/core/domain/usecases/get_tasks_for_date_usecase.dart';

part 'daily_list_event.dart';
part 'daily_list_state.dart';

class DailyListBloc extends Bloc<DailyListEvent, DailyListState> {
  final GetHabitsForDateUsecase getHabitsForDate;
  final GetRoutinesForDateUsecase getRoutinesForDate;
  final GetTasksForDateUsecase getTasksForDate;
  final logger = AppLogger.tag('DailyListBloc');

  static const int initialDaysEachSide = 15;
  static const int extendThreshold = 5;
  static const int daysToAdd = 10;

  DailyListBloc(
    this.getHabitsForDate,
    this.getRoutinesForDate,
    this.getTasksForDate,
  ) : super(HabitListInitial()) {
    on<DailyListDateChanged>(_onDateChanged);
    on<DailyListInitialize>(_onInitialize);
  }

  FutureOr<void> _onDateChanged(
    DailyListDateChanged event,
    Emitter<DailyListState> emit,
  ) async {
    if (state is! HabitListLoaded) return;
    final currentState = state as HabitListLoaded;
    emit(currentState.copyWith(isLoading: true));
    try {
      final newIndex = event.newIndex;
      final selectedDate = currentState.days[newIndex];
      final habits = await getHabitsForDate.call(selectedDate);
      final routines = await getRoutinesForDate.call(selectedDate);
      final tasks = await getTasksForDate.call(selectedDate);

      // Extend days if threshold reached
      List<DateTime> newDays = currentState.days;
      if (newIndex <= extendThreshold) {
        // extend days -1
        newDays = _extendDays(-1, currentState.days);
      } else if (newIndex >= currentState.days.length - extendThreshold - 1) {
        newDays = _extendDays(1, currentState.days);
      }

      final updatedNewIndex = newDays.indexWhere(
        (d) =>
            d.year == selectedDate.year &&
            d.month == selectedDate.month &&
            d.day == selectedDate.day,
      );

      emit(
        HabitListLoaded(
          habits: habits,
          routines: routines,
          days: newDays,
          tasks: tasks,
          selectedIndex: updatedNewIndex,
          isLoading: false,
        ),
      );
    } catch (e) {
      logger.error("Failed to load habits", e);
      emit(HabitListError("Failed to load habits"));
    }
  }

  List<DateTime> _extendDays(int direction, List<DateTime> existingList) {
    List<DateTime> newList;

    if (direction < 0) {
      final prepend = List.generate(daysToAdd, (i) {
        return (existingList.first.subtract(Duration(days: i + 1)));
      }).reversed.toList();

      newList = [...prepend, ...existingList];
    } else {
      final append = List.generate(daysToAdd, (i) {
        return (existingList.last.add(Duration(days: i + 1)));
      });

      newList = [...existingList, ...append];
    }
    return newList;
  }

  FutureOr<void> _onInitialize(
    DailyListInitialize event,
    Emitter<DailyListState> emit,
  ) async {
    emit(DailyListLoading());

    final today = DateTime.now();
    final initialDays = List.generate(
      initialDaysEachSide * 2 + 1,
      (i) => today.subtract(Duration(days: initialDaysEachSide - i)),
    );
    final initialIndex = initialDaysEachSide;
    try {
      // Load habits for the initial selected day
      final habits = await getHabitsForDate.call(initialDays[initialIndex]);
      final routines = await getRoutinesForDate.call(initialDays[initialIndex]);
      final tasks = await getTasksForDate(initialDays[initialIndex]);

      emit(
        HabitListLoaded(
          habits: habits,
          days: initialDays,
          routines: routines,
          tasks: tasks,
          selectedIndex: initialIndex,
          isLoading: false,
        ),
      );
    } catch (e) {
      logger.error("Failed to load initial habits", e);
      emit(HabitListError("Failed to load initial habits"));
    }
  }
}
