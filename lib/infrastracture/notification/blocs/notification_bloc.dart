import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/core/extensions/date_extensions.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/repositories/routine_repository.dart';
import 'package:mobile/infrastracture/notification/servcies/notification_service.dart';
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
  }

  FutureOr<void> _onStarted(
    NotificationStarted event,
    Emitter<NotificationState> emit,
  ) async {
    final routines = await routineRepository.fetchActiveRoutines();
    for (final routine in routines) {
      try {
        await routineNotificationService.schedule(routine, (
          scheduledDate,
        ) async {
          logger.debug("Checking routine $routine");
          if (_shouldSchedule(routine)) {
            await routineNotificationService.schedule(routine, (
              scheduledDate,
            ) async {
              final updated = routine.copyWith(lastScheduledAt: scheduledDate);
              await routineRepository.updateRoutine(updated);
            });
          }
        });
      } catch (e) {
        logger.error("Error happened", e);
      }
    }
  }

  bool _shouldSchedule(RoutineModel routine) {
    final now = (DateTime.now()).dateOnly;
    final last = routine.lastScheduledAt;
    if (last == null) return true;
    return now.isAfter((last).dateOnly);
  }
}
