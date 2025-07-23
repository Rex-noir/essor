import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/domain/models/habit_model.dart';
import 'package:mobile/domain/models/notification_entry_model.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/repositories/habit_repository.dart';
import 'package:mobile/domain/repositories/notification_entry_repository.dart';
import 'package:mobile/domain/repositories/routine_repository.dart';
import 'package:mobile/infrastructure/notification/models/schedulable_model.dart';
import 'package:mobile/infrastructure/notification/services/notification_service.dart';
import 'package:mobile/utils/app_logger.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService routineNotificationService;
  final RoutineRepository routineRepository;
  final HabitRepository habitRepository;
  final NotificationEntryRepository _entryRepository;

  final logger = TaggedLogger("NotificationBloc");

  NotificationBloc({
    required this.routineNotificationService,
    required this.routineRepository,
    required this.habitRepository,
    required NotificationEntryRepository entryRepo,
  }) : _entryRepository = entryRepo,
       super(NotificationInitial()) {
    on<NotificationStarted>(_onStarted);
    on<NotificationScheduleForRoutineRequested>(_onRoutineScheduleRequested);
    on<NotificationScheduleForHabitRequested>(_onHabitScheduleRequested);
    on<NotificationScheduleCancelRequestedForModel>(
      _onNotificationCancelRequested,
    );
  }

  FutureOr<void> _onStarted(
    NotificationStarted event,
    Emitter<NotificationState> emit,
  ) async {
    // Routines
    final routines = await routineRepository.fetchActiveRoutines();
    for (final routine in routines) {
      try {
        if (routine.shouldScheduleRoutine) {
          await _scheduleRoutine(routine);
        }
      } catch (e) {
        logger.error("Error happened", e);
        emit(NotificationError(e.toString()));
      }
    }
  }

  _syncScheduleToDatabase(
    String modelId,
    DateTime date,
    int notificationId,
  ) async {
    _entryRepository.insertEntry(
      NotificationEntryModel(
        modelId: modelId,
        notificationId: notificationId,
        date: date,
        id: null,
      ),
    );
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

  Future<void> _scheduleRoutine(RoutineModel routine) async {
    await routineNotificationService.schedule(routine, (
      scheduledDate,
      id,
    ) async {
      final updated = routine.copyWith(lastScheduledAt: scheduledDate);
      await routineRepository.updateRoutine(updated);
      _syncScheduleToDatabase(routine.id, scheduledDate, id);
    });
  }

  Future<void> _scheduleHabit(HabitModel habit) async {
    await routineNotificationService.schedule(habit, (scheduledDate, id) async {
      final updated = habit.copyWith(lastScheduledAt: scheduledDate);
      await habitRepository.updateHabit(updated);
      _syncScheduleToDatabase(habit.id, scheduledDate, id);
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

  Future<void> _onNotificationCancelRequested(
    NotificationScheduleCancelRequestedForModel event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final entries = await _entryRepository.getAllEntriesByModelId(
        event.model.id,
      );
      for (final entry in entries) {
        await routineNotificationService.cancelNotificationById(
          entry.notificationId,
        );
        await _entryRepository.deleteEntry(entry);
      }
    } catch (e) {
      logger.error("Error happened", e);
      emit(NotificationError(e.toString()));
    }
  }
}
