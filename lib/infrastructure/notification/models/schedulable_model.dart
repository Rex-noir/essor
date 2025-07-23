import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/date_extensions.dart';
import 'package:mobile/domain/enums/item_frequency.dart';

abstract class Schedulable {
  String get title;

  String? get description;

  DateTime get startDate;

  TimeOfDay get startTime;

  String get id;

  ItemFrequency get frequency;

  List<int> get weeklyDays;

  List<int> get monthlyDates;

  DateTime? get lastScheduledAt;

  int get interval;

  bool get shouldScheduleRoutine {
    final now = DateTime.now().dateOnly;
    if (lastScheduledAt == null) return true;
    return now.isAfter(lastScheduledAt!.dateOnly);
  }

  @override
  String toString() {
    return 'Schedulable('
        'id: $id, '
        'title: $title, '
        'description: $description, '
        'startDate: $startDate, '
        'startTime: $startTime, '
        'frequency: $frequency, '
        'weeklyDays: $weeklyDays, '
        'monthlyDates: $monthlyDates, '
        'lastScheduledAt: $lastScheduledAt, '
        'interval: $interval'
        ')';
  }
}
