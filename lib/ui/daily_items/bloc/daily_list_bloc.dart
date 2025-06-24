import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
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

  List<DateTime> _currentDays = [];
  int _currentSelectedIndex = 0;

  DailyListBloc(this.getHabitsForDate, this.getRoutinesForDate)
      : super(DailyListInitial()) {
    on<DailyListInitialize>(_onInitialize);
    on<DailyListDateChanged>(_onDateChanged);
  }

  Future<void> _onInitialize(
    DailyListInitialize event,
    Emitter<DailyListState> emit,
  ) async {
    logger.debug("Initializing daily list");
    emit(DailyListLoading());

    try {
      final today = DateTime.now().dateOnly;
      final initialDays = List.generate(
        initialDaysEachSide * 2 + 1,
        (i) => today.subtract(Duration(days: initialDaysEachSide - i)).dateOnly,
      );
      final initialIndex = initialDaysEachSide;
      final selectedDate = initialDays[initialIndex];

      logger.debug("Initial setup - Today: $today, Selected: $selectedDate");

      _currentDays = initialDays;
      _currentSelectedIndex = initialIndex;

      await _subscribeToCombinedStreams(
        selectedDate,
        emit,
        days: _currentDays,
        index: _currentSelectedIndex,
      );
    } catch (e) {
      logger.error("Failed to initialize daily list", e);
      emit(DailyListError("Failed to initialize daily list: $e"));
    }
  }

  Future<void> _onDateChanged(
    DailyListDateChanged event,
    Emitter<DailyListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DailyListLoaded) return;

    logger.debug("Date changed to index: ${event.newIndex}");
    emit(currentState.copyWith(isLoading: true));

    try {
      int newIndex = event.newIndex;
      DateTime selectedDate = currentState.days[newIndex];

      List<DateTime> newDays = currentState.days;

      if (newIndex <= extendThreshold) {
        logger.debug("Extending days backwards");
        newDays = _extendDays(-1, currentState.days);
        newIndex = newDays.indexWhere((d) => d.isSameDay(selectedDate));
      } else if (newIndex >= currentState.days.length - extendThreshold - 1) {
        logger.debug("Extending days forwards");
        newDays = _extendDays(1, currentState.days);
        newIndex = newDays.indexWhere((d) => d.isSameDay(selectedDate));
      }

      _currentDays = newDays;
      _currentSelectedIndex = newIndex;

      await _subscribeToCombinedStreams(
        selectedDate,
        emit,
        days: newDays,
        index: newIndex,
      );
    } catch (e) {
      logger.error("Failed to change date", e);
      emit(DailyListError("Failed to change date: $e"));
    }
  }

  Future<void> _subscribeToCombinedStreams(
    DateTime date,
    Emitter<DailyListState> emit, {
    required List<DateTime> days,
    required int index,
  }) async {
    final habitStream = getHabitsForDate.call(date);
    final routineStream = getRoutinesForDate.call(date);

    logger.debug("Subscribing to combined streams for date: $date");

    await emit.onEach(
      Rx.combineLatest2<List<HabitModel>, List<RoutineModel>, DailyListLoaded>(
        habitStream,
        routineStream,
        (habits, routines) {
          logger.debug(
              "Received ${habits.length} habits and ${routines.length} routines");
          return DailyListLoaded(
            habits: habits,
            routines: routines,
            days: days,
            selectedIndex: index,
            isLoading: false,
          );
        },
      ),
      onData: emit.call,
      onError: (error, stackTrace) {
        logger.error("Error combining streams", error);
        emit(DailyListError("Failed to load data: $error"));
      },
    );
  }

  List<DateTime> _extendDays(int direction, List<DateTime> existingList) {
    List<DateTime> newList;

    if (direction < 0) {
      final prepend = List.generate(daysToAdd, (i) {
        return existingList.first.subtract(Duration(days: i + 1)).dateOnly;
      }).reversed.toList();

      newList = [...prepend, ...existingList];
    } else {
      final append = List.generate(daysToAdd, (i) {
        return existingList.last.add(Duration(days: i + 1)).dateOnly;
      });

      newList = [...existingList, ...append];
    }

    logger.debug(
      "Extended days from ${existingList.length} to ${newList.length}",
    );
    return newList;
  }
}

// Extension to help with date comparison
extension DateTimeComparison on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
