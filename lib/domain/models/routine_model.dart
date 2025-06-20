import 'package:flutter/material.dart';
import 'package:mobile/domain/enums/item_frequency.dart';

class RoutineModel {
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
    required this.iconIndex,
    required this.syncVersion,
  });
}
