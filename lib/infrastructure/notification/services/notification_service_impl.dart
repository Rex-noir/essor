import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    if (model.interval == 0) {
      throw NotificationDailyIntervalIsZero();
    }

    final now = DateTime.now();
    final startDay = DateTime(
      model.startDate.year,
      model.startDate.month,
      model.startDate.day,
    );

    final occurrencesToSchedule = 10;

    for (int i = 0; i < occurrencesToSchedule; i++) {
      final scheduleDate = startDay.add(Duration(days: i * model.interval));

      final notificationTime = DateTime(
        scheduleDate.year,
        scheduleDate.month,
        scheduleDate.day,
        model.startTime.hour,
        model.startTime.minute,
      );

      if (!notificationTime.isBefore(now)) {
        await _scheduleRoutine(
          model,
          notificationTime,
          null, // one-time only
          scheduleDate,
        );
      }
    }
  }

  Future<void> _scheduleWeeklyNotifications(Schedulable model) async {
    if (model.weeklyDays.isEmpty) {
      throw NotificationWeeklyDaysEmptyFailure();
    }

    logger.debug(
      "Received _scheduleWeeklyNotifications notification for model $model",
    );

    final now = DateTime.now();
    final startMonth = DateTime(model.startDate.year, model.startDate.month, 1);

    // Schedule strictly from startMonth forward
    final monthsToSchedule = model.interval == 1 ? 3 : 2;

    for (int i = 0; i < monthsToSchedule; i++) {
      final targetMonth = DateTime(
        startMonth.year,
        startMonth.month + (i * model.interval),
        1,
      );

      final daysInMonth = DateUtils.getDaysInMonth(
        targetMonth.year,
        targetMonth.month,
      );

      for (int day = 1; day <= daysInMonth; day++) {
        final currentDate = DateTime(targetMonth.year, targetMonth.month, day);

        if (!model.weeklyDays.contains(currentDate.weekday)) {
          continue;
        }

        final notificationTime = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          model.startTime.hour,
          model.startTime.minute,
        );

        if (notificationTime.isBefore(now)) {
          continue;
        }

        logger.debug(
          "Scheduling notification on $notificationTime for model ${model.id}",
        );

        await _scheduleRoutine(
          model,
          notificationTime,
          null, // one-time only
          currentDate,
        );
      }
    }
  }

  Future<void> _scheduleMonthlyNotifications(Schedulable model) async {
    if (model.monthlyDates.isEmpty) {
      throw NotificationMonthlyDaysEmpty();
    }

    final now = DateTime.now();
    final startMonth = DateTime(model.startDate.year, model.startDate.month, 1);

    // Calculate current month relative to start
    final monthsDifference =
        (now.year - startMonth.year) * 12 + (now.month - startMonth.month);
    final currentIntervalMonth = (monthsDifference / model.interval).floor();

    // Find next valid interval month
    final nextIntervalMonth =
        monthsDifference % model.interval == 0 &&
            model.monthlyDates.any((day) => _isMonthDayUpcoming(now, day))
        ? currentIntervalMonth
        : currentIntervalMonth + 1;

    // Schedule for the next 2-3 interval months
    final monthsToSchedule = model.interval == 1 ? 3 : 2;

    for (int monthOffset = 0; monthOffset < monthsToSchedule; monthOffset++) {
      final targetMonth = DateTime(
        startMonth.year,
        startMonth.month + (nextIntervalMonth + monthOffset) * model.interval,
        1,
      );

      for (int day in model.monthlyDates) {
        try {
          final scheduleDate = DateTime(
            targetMonth.year,
            targetMonth.month,
            day,
          );

          final notificationTime = DateTime(
            scheduleDate.year,
            scheduleDate.month,
            scheduleDate.day,
            model.startTime.hour,
            model.startTime.minute,
          );

          if (!notificationTime.isBefore(now)) {
            await _scheduleRoutine(
              model,
              notificationTime,
              DateTimeComponents.dateAndTime,
              scheduleDate,
            );
          }
        } catch (e) {
          // Skip invalid dates (like Feb 30th)
          continue;
        }
      }
    }
  }

  Future<void> _scheduleRoutine(
    Schedulable model,
    DateTime notificationTime,
    DateTimeComponents? dateTimeComponents,
    DateTime scheduleDate,
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

    // Generate unique ID based on model ID and schedule date
    final uniqueId = __generateNotificationId(model.id, scheduleDate);

    return scheduleSimpleNotification(
      id: uniqueId,
      title: title,
      body: body,
      scheduledTime: notificationTime,
      payload: jsonEncode({
        'id': model.id,
        'time': notificationTime.toIso8601String(),
        'date': scheduleDate.toIso8601String(),
        'item': model is HabitModel ? "HABIT" : "ROUTINE",
      }),
      matchDateTimeComponents: dateTimeComponents,
    );
  }

  /// Generate a unique ID based on the model ID and schedule date
  int __generateNotificationId(String modelId, DateTime scheduleDate) {
    final dateString =
        '${scheduleDate.year}${scheduleDate.month.toString().padLeft(2, '0')}${scheduleDate.day.toString().padLeft(2, '0')}';
    final combinedString = '$modelId$dateString';
    return combinedString.hashCode.abs();
  }

  /// Check if a month day is still upcoming in the current month
  bool _isMonthDayUpcoming(DateTime now, int day) {
    if (day > now.day) return true;
    if (day == now.day) {
      final todayScheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      );
      return todayScheduledTime.isAfter(now);
    }
    return false;
  }
}
