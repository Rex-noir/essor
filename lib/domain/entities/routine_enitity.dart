// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mobile/domain/entities/habit_entity.dart';
import 'package:mobile/domain/entities/task_entity.dart';
import 'package:mobile/domain/enums/day_of_week.dart';

class RoutineEntity {
  final String id;
  final String title;
  final DateTime startDate;
  final TimeOfDay startTime;
  final List<TaskEntity> tasks;
  final ItemFrequency frequency;
  final List<DayOfWeek> weeklyDays;
  final List<int> monthlyDates;
  final int interval;
  final bool isActive;
  final int iconIndex;

  RoutineEntity({
    required this.id,
    required this.title,
    required this.startDate,
    required this.startTime,
    required this.tasks,
    required this.frequency,
    required this.weeklyDays,
    required this.monthlyDates,
    required this.interval,
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
    int? interval,
    bool? isActive,
    int? iconIndex,
  }) {
    return RoutineEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      tasks: tasks ?? this.tasks,
      frequency: frequency ?? this.frequency,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      monthlyDates: monthlyDates ?? this.monthlyDates,
      interval: interval ?? this.interval,
      isActive: isActive ?? this.isActive,
      iconIndex: iconIndex ?? this.iconIndex,
    );
  }

  @override
  String toString() {
    final startTimeFormatted =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    return 'RoutineEntity('
        'id: $id, '
        'title: $title, '
        'startDate: ${startDate.toIso8601String()}, '
        'startTime: $startTimeFormatted, '
        'tasks: ${tasks.map((t) => t.toString()).toList()}, '
        'frequency: $frequency, '
        'weeklyDays: ${weeklyDays.map((d) => d.name).toList()}, '
        'monthlyDates: $monthlyDates, '
        'interval: $interval, '
        'isActive: $isActive, '
        'iconIndex: $iconIndex'
        ')';
  }
}

String getRoutineRepeatLabel(ItemFrequency frequency, int interval) {
  switch (frequency) {
    case ItemFrequency.daily:
      return interval == 1 ? "Every day" : "Every $interval days";
    case ItemFrequency.weekly:
      return interval == 1 ? "Every week" : "Every $interval weeks";
    case ItemFrequency.monthly:
      return interval == 1 ? "Every month" : "Every $interval months";
  }
}

extension RoutineEnitityX on RoutineEntity {
  RoutineEntity addTask(TaskEntity task) {
    return copyWith(tasks: [...tasks, task]);
  }

  RoutineEntity removeTask(String taskId) {
    return copyWith(tasks: tasks.where((t) => t.id != taskId).toList());
  }

  RoutineEntity updateTask(TaskEntity updatedTask) {
    final updatedList = tasks
        .map((t) => t.id == updatedTask.id ? updatedTask : t)
        .toList();
    return copyWith(tasks: updatedList);
  }
}
