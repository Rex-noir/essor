import 'package:mobile/core/extensions/date_extensions.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/infrastructure/notification/models/schedulable_model.dart';
import 'package:mobile/infrastructure/notification/services/notification_service.dart';
import 'package:mobile/utils/app_logger.dart';

class NotificationServiceImpl extends NotificationService<Schedulable> {
  NotificationServiceImpl(super.plugin);

  final logger = TaggedLogger("NotificationServiceImpl");

  @override
  Future<void> schedule(
    Schedulable model,
    NotificationCallback onScheduled,
  ) async {
    await cancelNotification(model.id);
    this.onScheduled = onScheduled;

    switch (model.frequency) {
      case ItemFrequency.daily:
        await _scheduleDailyNotifications(model);
        break;
      case ItemFrequency.weekly:
        await _scheduleWeeklyNotifications(model);
        break;
      case ItemFrequency.monthly:
        await _scheduleMonthlyNotifications(model);
        break;
    }
  }

  Future<void> _scheduleDailyNotifications(Schedulable model) async {
    final now = DateTime.now();

    logger.debug("Scheduling daily notification $model");

    for (int i = 0; i < 30; i++) {
      final scheduleDate = now.add(Duration(days: i));

      if (_shouldScheduleForDate(model, scheduleDate)) {
        final notificationTime = DateTime(
          scheduleDate.year,
          scheduleDate.month,
          scheduleDate.day,
          model.startTime.hour,
          model.startTime.minute,
        );

        if (notificationTime.isAfter(now)) {
          await _scheduleRoutine(model, notificationTime);
        }
      }
    }
  }

  Future<void> _scheduleWeeklyNotifications(Schedulable model) async {
    final now = DateTime.now();

    for (int week = 0; week < 12; week++) {
      final baseDate = now.add(Duration(days: week * 7));
      for (int weekday in model.weeklyDays) {
        final scheduleDate = baseDate.getNextWeekDay(weekday);
        if (_shouldScheduleForDate(model, scheduleDate)) {
          final notificationTime = DateTime(
            scheduleDate.year,
            scheduleDate.month,
            scheduleDate.day,
            model.startTime.hour,
            model.startTime.minute,
          );
          if (notificationTime.isAfter(now)) {
            await _scheduleRoutine(model, notificationTime);
          }
        }
      }
    }
  }

  Future<void> _scheduleMonthlyNotifications(Schedulable model) async {
    final now = DateTime.now();

    for (int month = 0; month < 12; month++) {
      final targetMonth = DateTime(now.year, now.month + month, 1);

      for (int day in model.monthlyDates) {
        try {
          final scheduleDate = DateTime(
            targetMonth.year,
            targetMonth.month,
            day,
          );

          if (_shouldScheduleForDate(model, scheduleDate)) {
            final notificationTime = DateTime(
              scheduleDate.year,
              scheduleDate.month,
              scheduleDate.day,
              model.startTime.hour,
              model.startTime.minute,
            );
            if (notificationTime.isAfter(now)) {
              await _scheduleRoutine(model, notificationTime);
            }
          }
        } catch (e) {
          continue;
        }
      }
    }
  }

  Future<void> _scheduleRoutine(Schedulable model, DateTime notificationTime) {
    return scheduleSimpleNotification(
      id: generateId(model.id),
      title: model.title,
      body: model.description ?? "Time for your model'",
      scheduledTime: notificationTime,
      payload: model.id,
    );
  }

  bool _shouldScheduleForDate(Schedulable model, DateTime scheduleDate) {
    final daysDifference = scheduleDate.difference(model.startDate).inDays;
    switch (model.frequency) {
      case ItemFrequency.daily:
        return daysDifference >= 0 && daysDifference % model.interval == 0;
      case ItemFrequency.weekly:
        final weeksDifference = (daysDifference / 7).floor();
        return model.weeklyDays.contains(scheduleDate.weekday) &&
            weeksDifference >= 0 &&
            weeksDifference % model.interval == 0;
      case ItemFrequency.monthly:
        final isMatchingDay = model.monthlyDates.contains(scheduleDate.day);
        final monthDiff =
            (scheduleDate.year - model.startDate.year) * 12 +
            (scheduleDate.month - model.startDate.month);
        return isMatchingDay &&
            monthDiff >= 0 &&
            monthDiff % model.interval == 0;
    }
  }
}
