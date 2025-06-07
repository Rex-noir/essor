import 'package:flutter/material.dart';
import 'package:mobile/features/daily_items/domain/entities/habit_entity.dart';
import 'package:mobile/features/daily_items/domain/entities/task_entity.dart';

class RoutineEntity {
  final String id;
  final String title;
  final DateTime startDate;
  final TimeOfDay startTime;
  final List<int> repeatDays;
  final List<TaskEntity> tasks;
  final ItemFrequency frequency;
  final List<DayOfWeek> weeklyDays;
  final List<int> monthlyDates;
  final int repeatEvery;
  final bool isActive;

  RoutineEntity({
    required this.id,
    required this.title,
    required this.startDate,
    required this.startTime,
    required this.repeatDays,
    required this.tasks,
    required this.frequency,
    required this.weeklyDays,
    required this.monthlyDates,
    required this.repeatEvery,
    required this.isActive,
  });
}
