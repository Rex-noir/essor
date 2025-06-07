import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/core/utils/app_logger.dart';
import 'package:mobile/features/daily_items/domain/entities/habit_entity.dart';
import 'package:mobile/features/daily_items/domain/usecases/get_habits_for_date_usecase.dart';

part 'habit_list_event.dart';
part 'habit_list_state.dart';

class HabitListBloc extends Bloc<HabitListEvent, HabitListState> {
  final GetHabitsForDateUsecase getHabitsForDate;
  final logger = AppLogger.tag('HabitListBloc');

  static const int initialDaysEachSide = 15;
  static const int extendThreshold = 5;
  static const int daysToAdd = 10;

  HabitListBloc(this.getHabitsForDate) : super(HabitListInitial()) {
    on<HabitListDateChanged>(_onDateChanged);
    on<HabitListInitialize>(_onInitialize);
  }

  FutureOr<void> _onDateChanged(
    HabitListDateChanged event,
    Emitter<HabitListState> emit,
  ) async {
    if (state is! HabitListLoaded) return;
    final currentState = state as HabitListLoaded;
    emit(HabitListLoading());
    try {
      final newIndex = event.newIndex;
      final selectedDate = currentState.days[newIndex];
      final habits = await getHabitsForDate.call(selectedDate);

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
          days: newDays,
          selectedIndex: updatedNewIndex,
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
    HabitListInitialize event,
    Emitter<HabitListState> emit,
  ) async {
    emit(HabitListLoading());

    final today = DateTime.now();
    final initialDays = List.generate(
      initialDaysEachSide * 2 + 1,
      (i) => today.subtract(Duration(days: initialDaysEachSide - i)),
    );
    final initialIndex = initialDaysEachSide;
    try {
      // Load habits for the initial selected day
      final habits = await getHabitsForDate.call(initialDays[initialIndex]);

      emit(
        HabitListLoaded(
          habits: habits,
          days: initialDays,
          selectedIndex: initialIndex,
        ),
      );
    } catch (e) {
      logger.error("Failed to load initial habits", e);
      emit(HabitListError("Failed to load initial habits"));
    }
  }
}
