import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/domain/models/habit_model.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/repositories/habit_repository.dart';
import 'package:mobile/domain/repositories/routine_repository.dart';
import 'package:mobile/infrastructure/notification/services/notification_service.dart';
import 'package:mobile/utils/app_logger.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService routineNotificationService;
  final RoutineRepository routineRepository;
  final HabitRepository habitRepository;

  final logger = TaggedLogger("NotificationBloc");

  NotificationBloc({
    required this.routineNotificationService,
    required this.routineRepository,
    required this.habitRepository,
  }) : super(NotificationInitial()) {
    on<NotificationStarted>(_onStarted);
    on<NotificationScheduleForRoutineRequested>(_onRoutineScheduleRequested);
    on<NotificationScheduleForHabitRequested>(_onHabitScheduleRequested);
  }

  FutureOr<void> _onStarted(
    NotificationStarted event,
    Emitter<NotificationState> emit,
  ) async {
    // Routines
    final routines = await routineRepository.fetchActiveRoutines();
    for (final routine in routines) {
      try {
        await routineNotificationService.schedule(routine, (
          scheduledDate,
        ) async {
          logger.debug("Checking routine $routine");
          if ((routine.shouldScheduleRoutine)) {
            await _scheduleRoutine(routine);
          }
        });
      } catch (e) {
        logger.error("Error happened", e);
        emit(NotificationError(e.toString()));
      }
    }
  }

  _scheduleRoutine(RoutineModel routine) async {
    await routineNotificationService.schedule(routine, (scheduledDate) async {
      final updated = routine.copyWith(lastScheduledAt: scheduledDate);
      await routineRepository.updateRoutine(updated);
    });
  }

  Future<void> _onRoutineScheduleRequested(
    NotificationScheduleForRoutineRequested event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (event.model.shouldScheduleRoutine) {
        await _scheduleRoutine(event.model);
      }
    } catch (e) {
      logger.error("Error happened", e);
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _scheduleHabit(HabitModel habit) async {
    await routineNotificationService.schedule(habit, (scheduledDate) async {
      final updated = habit.copyWith(lastScheduledAt: scheduledDate);
      await habitRepository.updateHabit(updated);
    });
  }

  Future<void> _onHabitScheduleRequested(
    NotificationScheduleForHabitRequested event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (event.model.shouldScheduleRoutine) {
        await _scheduleHabit(event.model);
      }
    } catch (e) {
      logger.error("Error happened", e);
      emit(NotificationError(e.toString()));
    }
  }
}
