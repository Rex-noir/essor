import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/date_extensions.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/infrastructure/notification/services/notification_service.dart';

class RoutineModel implements Notifiable {
  @override
  final String id;
  final String title;
  final String? description;
  final DateTime startDate;
  final List<int> weeklyDays;
  final ItemFrequency frequency;
  final List<int> monthlyDates;
  final TimeOfDay startTime;

  final int interval;
  final bool isShared;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int syncVersion;
  final DateTime? lastScheduledAt;
  final int iconIndex;

  RoutineModel({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.startDate,
    required this.weeklyDays,
    required this.frequency,
    required this.monthlyDates,
    required this.interval,
    required this.isShared,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.lastScheduledAt,
    required this.iconIndex,
    required this.syncVersion,
  });

  RoutineModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    List<int>? weeklyDays,
    ItemFrequency? frequency,
    List<int>? monthlyDates,
    TimeOfDay? startTime,
    int? interval,
    bool? isShared,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? syncVersion,
    DateTime? lastScheduledAt,
    int? iconIndex,
  }) {
    return RoutineModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      weeklyDays: weeklyDays ?? List.from(this.weeklyDays),
      frequency: frequency ?? this.frequency,
      monthlyDates: monthlyDates ?? List.from(this.monthlyDates),
      startTime: startTime ?? this.startTime,
      interval: interval ?? this.interval,
      isShared: isShared ?? this.isShared,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncVersion: syncVersion ?? this.syncVersion,
      lastScheduledAt: lastScheduledAt ?? this.lastScheduledAt,
      iconIndex: iconIndex ?? this.iconIndex,
    );
  }

  @override
  String toString() {
    return 'RoutineModel('
        'id: $id, '
        'title: $title, '
        'description: $description, '
        'startDate: $startDate, '
        'weeklyDays: $weeklyDays, '
        'frequency: $frequency, '
        'monthlyDates: $monthlyDates, '
        'startTime: ${startTime.toString()}, '
        'interval: $interval, '
        'isShared: $isShared, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'deletedAt: $deletedAt, '
        'syncVersion: $syncVersion, '
        'lastScheduledAt: $lastScheduledAt, '
        'iconIndex: $iconIndex'
        ')';
  }

  bool get shouldScheduleRoutine {
    final now = DateTime.now().dateOnly;
    if (lastScheduledAt == null) return true;
    return now.isAfter(lastScheduledAt!.dateOnly);
  }
}
