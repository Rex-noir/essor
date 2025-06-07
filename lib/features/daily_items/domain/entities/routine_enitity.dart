// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final int iconIndex;

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
    this.iconIndex = 1,
  });

  RoutineEntity copyWith({
    String? id,
    String? title,
    DateTime? startDate,
    TimeOfDay? startTime,
    List<int>? repeatDays,
    List<TaskEntity>? tasks,
    ItemFrequency? frequency,
    List<DayOfWeek>? weeklyDays,
    List<int>? monthlyDates,
    int? repeatEvery,
    bool? isActive,
    int? iconIndex,
  }) {
    return RoutineEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      repeatDays: repeatDays ?? this.repeatDays,
      tasks: tasks ?? this.tasks,
      frequency: frequency ?? this.frequency,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      monthlyDates: monthlyDates ?? this.monthlyDates,
      repeatEvery: repeatEvery ?? this.repeatEvery,
      isActive: isActive ?? this.isActive,
      iconIndex: iconIndex ?? this.iconIndex,
    );
  }
}
