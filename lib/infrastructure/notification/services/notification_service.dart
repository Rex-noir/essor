import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/infrastructure/notification/models/schedulable_model.dart';
import 'package:mobile/utils/app_logger.dart';
import 'package:timezone/timezone.dart' as tz;

typedef NotificationCallback = void Function(DateTime date, int id);

abstract class NotificationService<T extends Schedulable> {
  final FlutterLocalNotificationsPlugin _plugin;

  late NotificationCallback onScheduled;

  final logger = TaggedLogger("NotificationService");

  NotificationService(this._plugin);

  Future<void> schedule(T data, NotificationCallback onScheduled);

  @protected
  Future<void> cancelNotification(String id) async {
    await _plugin.cancel(generateId(id));
  }

  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  Future<void> cancelNotificationById(int id) async {
    await _plugin.cancel(id);
  }

  Future<List<ActiveNotification>> getAllActiveNotifications() async {
    return _plugin.getActiveNotifications();
  }

  @protected
  Future<void> rescheduleAll(
    List<T> data,
    NotificationCallback onScheduled,
  ) async {
    for (final item in data) {
      await cancelNotification(item.id);
      await schedule(item, onScheduled);
    }
  }

  Future<List<PendingNotificationRequest>>
  getPendingNotificationRequests() async {
    return await _plugin.pendingNotificationRequests();
  }

  @protected
  Future<void> scheduleSimpleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required DateTimeComponents? matchDateTimeComponents,
    String? payload,
    String channelId = 'default_channer',
    String channelName = "Default",
    String channelDescription = "Default Notifications",
  }) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );

    final iosPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformChannelSpecifics,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: matchDateTimeComponents,
    );
    onScheduled(scheduledTime, id);
  }

  @protected
  int generateId(String baseId) {
    return baseId.hashCode & 0x7FFFFFFF;
  }
}
