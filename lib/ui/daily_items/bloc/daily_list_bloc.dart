import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/core/extensions/date_extensions.dart';
import 'package:mobile/domain/models/habit_model.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/models/task_model.dart';
import 'package:mobile/domain/usecases/get_habits_for_date_usecase.dart';
import 'package:mobile/domain/usecases/get_routines_for_date_usecase.dart';
import 'package:mobile/utils/app_logger.dart';

part 'daily_list_event.dart';
part 'daily_list_state.dart';

class DailyListBloc extends Bloc<DailyListEvent, DailyListState> {
  final GetHabitsForDateUsecase getHabitsForDate;
  final GetRoutinesForDateUsecase getRoutinesForDate;
  final logger = AppLogger.tag('DailyListBloc');

  static const int initialDaysEachSide = 15;
  static const int extendThreshold = 5;
  static const int daysToAdd = 10;

  DailyListBloc(this.getHabitsForDate, this.getRoutinesForDate)
    : super(DailyListInitial()) {
    on<DailyListDateChanged>(_onDateChanged);
    on<DailyListInitialize>(_onInitialize);
    on<DailyListRefreshRequested>(_onDailyListRefreshRequested);
  }

  FutureOr<void> _onDateChanged(
    DailyListDateChanged event,
    Emitter<DailyListState> emit,
  ) async {
    if (state is! DailyListLoaded) return;
    final currentState = state as DailyListLoaded;
    emit(currentState.copyWith(isLoading: true));
    try {
      final newIndex = event.newIndex;
      final selectedDate = currentState.days[newIndex];
      final habits = await getHabitsForDate.call(selectedDate);
      final routines = await getRoutinesForDate.call(selectedDate);

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
        DailyListLoaded(
          habits: habits,
          routines: routines,
          days: newDays,
          selectedIndex: updatedNewIndex,
          isLoading: false,
        ),
      );
    } catch (e) {
      logger.error("Failed to load habits", e);
      emit(DailyListError("Failed to load habits"));
    }
  }

  List<DateTime> _extendDays(int direction, List<DateTime> existingList) {
    List<DateTime> newList;

    if (direction < 0) {
      final prepend = List.generate(daysToAdd, (i) {
        return (existingList.first.subtract(Duration(days: i + 1)).dateOnly);
      }).reversed.toList();

      newList = [...prepend, ...existingList];
    } else {
      final append = List.generate(daysToAdd, (i) {
        return (existingList.last.add(Duration(days: i + 1)).dateOnly);
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

    final today = DateTime.now().dateOnly;
    final initialDays = List.generate(
      initialDaysEachSide * 2 + 1,
      (i) => today.subtract(Duration(days: initialDaysEachSide - i)).dateOnly,
    );
    final initialIndex = initialDaysEachSide;
    try {
      // Load habits for the initial selected day
      final habits = await getHabitsForDate.call(initialDays[initialIndex]);
      final routines = await getRoutinesForDate.call(initialDays[initialIndex]);

      emit(
        DailyListLoaded(
          habits: habits,
          days: initialDays,
          routines: routines,
          selectedIndex: initialIndex,
          isLoading: false,
        ),
      );
    } catch (e) {
      logger.error("Failed to load initial habits", e);
      emit(DailyListError("Failed to load initial habits"));
    }
  }

  _onDailyListRefreshRequested(
    DailyListRefreshRequested event,
    Emitter<DailyListState> emit,
  ) async {
    if (state is! DailyListLoaded) {
      return;
    }
    logger.debug("Refreshing daily list");
    final currentState = state as DailyListLoaded;

    emit(DailyListLoading());
    try {
      final selectedDate =
          (event.date ?? currentState.days[currentState.selectedIndex])
              .dateOnly;
      final refreshedHabits = await getHabitsForDate.call(selectedDate);
      final refreshedRoutines = await getRoutinesForDate.call(selectedDate);

      logger.debug("refreshed habits: $refreshedHabits");
      logger.debug("refreshed routines: $refreshedRoutines");

      emit(
        DailyListLoaded(
          habits: refreshedHabits,
          routines: refreshedRoutines,
          days: currentState.days,
          selectedIndex: currentState.selectedIndex,
          isLoading: false,
        ),
      );
    } catch (e) {
      logger.error("Failed to refresh daily list", e);
      emit(DailyListError("Failed to refresh daily list"));
    }
  }
}
