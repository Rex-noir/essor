import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobile/data/dtos/habit_dto.dart';
import 'package:mobile/data/dtos/task_dto.dart';
import 'package:mobile/domain/entities/habit_entity.dart';
import 'package:mobile/domain/entities/routine_enitity.dart';
import 'package:mobile/domain/enums/day_of_week.dart';

class RoutineDto with EquatableMixin {
  final String id;
  final String title;
  final DateTime startDate;
  final TimeOfDay startTime;
  final List<TaskDto> tasks;
  final ItemFrequency frequency;
  final List<DayOfWeek> weeklyDays;
  final List<int> monthlyDates;
  final int interval;
  final bool isActive;

  RoutineDto({
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
  });

  RoutineDto copyWith({
    String? id,
    String? title,
    DateTime? startDate,
    TimeOfDay? startTime,
    List<int>? repeatDays,
    List<TaskDto>? tasks,
    ItemFrequency? frequency,
    List<DayOfWeek>? weeklyDays,
    List<int>? monthlyDates,
    int? interval,
    bool? isActive,
  }) {
    return RoutineDto(
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'start_date': startDate.millisecondsSinceEpoch,
      'start_time': {'hour': startTime.hour, 'minute': startTime.minute},
      'habits': tasks.map((x) => x.toMap()).toList(),
      'frequency': frequency.index,
      'weekly_days': weeklyDays.map((x) => x.index).toList(),
      'monthly_dates': monthlyDates,
      'interval': interval,
      'is_active': isActive,
    };
  }

  factory RoutineDto.fromMap(Map<String, dynamic> map) {
    return RoutineDto(
      id: map['id'] as String,
      title: map['title'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['start_date'] as int),
      startTime: TimeOfDay(
        hour: map['start_time']['hour'] as int,
        minute: map['start_time']['minute'] as int,
      ),
      tasks: List<TaskDto>.from(
        (map['habits'] as List).map(
          (x) => HabitDto.fromMap(x as Map<String, dynamic>),
        ),
      ),
      frequency: ItemFrequency.values[map['frequency'] as int],
      weeklyDays: List<DayOfWeek>.from(
        (map['weekly_days'] as List).map((x) => DayOfWeek.values[x as int]),
      ),
      monthlyDates: List<int>.from(map['monthly_dates']),
      interval: map['interval'] as int,
      isActive: map['is_active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoutineDto.fromJson(String source) =>
      RoutineDto.fromMap(json.decode(source) as Map<String, dynamic>);

  RoutineEntity toEntity() {
    return RoutineEntity(
      id: id,
      title: title,
      startDate: startDate,
      startTime: startTime,
      tasks: tasks.map((h) => h.toEntity()).toList(),
      frequency: frequency,
      weeklyDays: weeklyDays,
      monthlyDates: monthlyDates,
      interval: interval,
      isActive: isActive,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
    id,
    title,
    startDate,
    startTime,
    tasks,
    frequency,
    weeklyDays,
    monthlyDates,
    interval,
    isActive,
  ];
}
