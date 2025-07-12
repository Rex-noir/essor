import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/repositories/routine_repository.dart';
import 'package:mobile/infrastructure/notification/services/notification_service.dart';
import 'package:mobile/utils/app_logger.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService routineNotificationService;
  final RoutineRepository routineRepository;

  final logger = TaggedLogger("NotificationBloc");

  NotificationBloc({
    required this.routineNotificationService,
    required this.routineRepository,
  }) : super(NotificationInitial()) {
    on<NotificationStarted>(_onStarted);
    on<NotificationForRoutineRequested>(_onRoutineScheduleRequested);
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
    NotificationForRoutineRequested event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (event.routine.shouldScheduleRoutine) {
        await _scheduleRoutine(event.routine);
      }
    } catch (e) {
      logger.error("Error happened", e);
      emit(NotificationError(e.toString()));
    }
  }
}
