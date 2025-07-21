import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/core/extensions/date_extensions.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/domain/models/habit_model.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/infrastructure/notification/failures/notification_failure.dart';
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
    logger.debug("Scheduling daily notification $model");

    if (model.interval == 0) {
      throw NotificationDailyIntervalIsZero();
    }

    for (int i = 0; i < 30; i++) {
      final scheduleDate = model.startDate.add(Duration(days: i));

      if (_shouldScheduleForDate(model, scheduleDate)) {
        final notificationTime = DateTime(
          scheduleDate.year,
          scheduleDate.month,
          scheduleDate.day,
          model.startTime.hour,
          model.startTime.minute,
        );

        if (!notificationTime.isBefore(DateTime.now())) {
          await _scheduleRoutine(
            model,
            notificationTime,
            DateTimeComponents.dateAndTime,
          );
        }
      }
    }
  }

  Future<void> _scheduleWeeklyNotifications(Schedulable model) async {
    if (model.weeklyDays.isEmpty) {
      throw NotificationWeeklyDaysEmptyFailure();
    }
    for (int week = 0; week < 12; week++) {
      final baseDate = model.startDate.add(Duration(days: week * 7));
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
          if (!notificationTime.isBefore(DateTime.now())) {
            await _scheduleRoutine(
              model,
              notificationTime,
              DateTimeComponents.dateAndTime,
            );
          }
        }
      }
    }
  }

  Future<void> _scheduleMonthlyNotifications(Schedulable model) async {
    if (model.monthlyDates.isEmpty) {
      throw NotificationMonthlyDaysEmpty();
    }
    for (int month = 0; month < 12; month++) {
      final targetMonth = DateTime(
        model.startDate.year,
        model.startDate.month + month,
        1,
      );

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
            if (!notificationTime.isBefore(DateTime.now())) {
              await _scheduleRoutine(
                model,
                notificationTime,
                DateTimeComponents.dateAndTime,
              );
            }
          }
        } catch (e) {
          continue;
        }
      }
    }
  }

  Future<void> _scheduleRoutine(
    Schedulable model,
    DateTime notificationTime,
    DateTimeComponents dateTimeComponents,
  ) {
    String title;
    String body;

    if (model is HabitModel) {
      title = "Habit Reminder: ${model.title}";
      body = model.description?.isNotEmpty == true
          ? model.description!
          : "It's time to build your habit: '${model.title}'";
    } else if (model is RoutineModel) {
      title = "Routine Reminder: ${model.title}";
      body = model.description?.isNotEmpty == true
          ? model.description!
          : "Start your routine: '${model.title}'";
    } else {
      // fallback for other possible schedulables
      title = "Reminder: ${model.title}";
      body = model.description?.isNotEmpty == true
          ? model.description!
          : "Time for '${model.title}'";
    }

    return scheduleSimpleNotification(
      id: generateId(model.id),
      title: title,
      body: body,
      scheduledTime: notificationTime,
      payload: model.id,
      matchDateTimeComponents: dateTimeComponents,
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
