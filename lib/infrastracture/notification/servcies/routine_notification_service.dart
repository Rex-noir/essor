import 'package:mobile/core/extensions/date_extensions.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/utils/app_logger.dart';

import 'notification_service.dart';

class RoutineNotificationService extends NotificationService<RoutineModel> {
  RoutineNotificationService(super.plugin);

  final logger = TaggedLogger("RoutineNotificationService");

  @override
  Future<void> schedule(
    RoutineModel routine,
    NotificationCallback onScheduled,
  ) async {
    await cancelNotification(routine.id);
    this.onScheduled = onScheduled;

    switch (routine.frequency) {
      case ItemFrequency.daily:
        await _scheduleDailyNotifications(routine);
        break;
      case ItemFrequency.weekly:
        await _scheduleWeeklyNotifications(routine);
        break;
      case ItemFrequency.monthly:
        await _scheduleMonthlyNotifications(routine);
        break;
    }
  }

  Future<void> _scheduleDailyNotifications(RoutineModel routine) async {
    final now = DateTime.now();

    logger.debug("Scheduling daily notification $routine");

    for (int i = 0; i < 30; i++) {
      final scheduleDate = now.add(Duration(days: i));

      if (_shouldScheduleForDate(routine, scheduleDate)) {
        final notificationTime = DateTime(
          scheduleDate.year,
          scheduleDate.month,
          scheduleDate.day,
          routine.startTime.hour ?? 0,
          routine.startTime.minute ?? 0,
        );

        if (notificationTime.isAfter(now)) {
          await _scheduleRoutine(routine, notificationTime);
        }
      }
    }
  }

  Future<void> _scheduleWeeklyNotifications(RoutineModel routine) async {
    final now = DateTime.now();

    for (int week = 0; week < 12; week++) {
      final baseDate = now.add(Duration(days: week * 7));
      for (int weekday in routine.weeklyDays) {
        final scheduleDate = baseDate.getNextWeekDay(weekday);
        if (_shouldScheduleForDate(routine, scheduleDate)) {
          final notificationTime = DateTime(
            scheduleDate.year,
            scheduleDate.month,
            scheduleDate.day,
            routine.startTime.hour ?? 9,
            routine.startTime.minute ?? 0,
          );
          if (notificationTime.isAfter(now)) {
            await _scheduleRoutine(routine, notificationTime);
          }
        }
      }
    }
  }

  Future<void> _scheduleMonthlyNotifications(RoutineModel routine) async {
    final now = DateTime.now();

    for (int month = 0; month < 12; month++) {
      final targetMonth = DateTime(now.year, now.month + month, 1);

      for (int day in routine.monthlyDates) {
        try {
          final scheduleDate = DateTime(
            targetMonth.year,
            targetMonth.month,
            day,
          );

          if (_shouldScheduleForDate(routine, scheduleDate)) {
            final notificationTime = DateTime(
              scheduleDate.year,
              scheduleDate.month,
              scheduleDate.day,
              routine.startTime.hour ?? 0,
              routine.startTime.minute ?? 0,
            );
            if (notificationTime.isAfter(now)) {
              await _scheduleRoutine(routine, notificationTime);
            }
          }
        } catch (e) {
          continue;
        }
      }
    }
  }

  Future<void> _scheduleRoutine(
    RoutineModel routine,
    DateTime notificationTime,
  ) {
    return scheduleSimpleNotification(
      id: generateId(routine.id),
      title: routine.title,
      body: routine.description ?? "Time for your routine'",
      scheduledTime: notificationTime,
      payload: routine.id,
    );
  }

  bool _shouldScheduleForDate(RoutineModel routine, DateTime scheduleDate) {
    final daysDifference = scheduleDate.difference(routine.startDate).inDays;
    switch (routine.frequency) {
      case ItemFrequency.daily:
        return daysDifference >= 0 && daysDifference % routine.interval == 0;
      case ItemFrequency.weekly:
        final weeksDifference = (daysDifference / 7).floor();
        return routine.weeklyDays.contains(scheduleDate.weekday) &&
            weeksDifference >= 0 &&
            weeksDifference % routine.interval == 0;
      case ItemFrequency.monthly:
        final isMatchingDay = routine.monthlyDates.contains(scheduleDate.day);
        final monthDiff =
            (scheduleDate.year - routine.startDate.year) * 12 +
            (scheduleDate.month - routine.startDate.month);
        return isMatchingDay &&
            monthDiff >= 0 &&
            monthDiff % routine.interval == 0;
    }
  }
}
