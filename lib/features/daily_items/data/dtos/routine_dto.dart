import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobile/features/daily_items/data/dtos/habit_dto.dart';
import 'package:mobile/features/daily_items/domain/entities/habit_entity.dart';
import 'package:mobile/features/daily_items/domain/entities/routine_enitity.dart';

class RoutineDto with EquatableMixin {
  final String id;
  final String title;
  final DateTime startDate;
  final TimeOfDay startTime;
  final List<int> repeatDays;
  final List<HabitDto> habits;
  final ItemFrequency frequency;
  final List<DayOfWeek> weeklyDays;
  final List<int> monthlyDates;
  final int repeatEvery;
  final bool isActive;

  RoutineDto({
    required this.id,
    required this.title,
    required this.startDate,
    required this.startTime,
    required this.repeatDays,
    required this.habits,
    required this.frequency,
    required this.weeklyDays,
    required this.monthlyDates,
    required this.repeatEvery,
    required this.isActive,
  });

  RoutineDto copyWith({
    String? id,
    String? title,
    DateTime? startDate,
    TimeOfDay? startTime,
    List<int>? repeatDays,
    List<HabitDto>? habits,
    ItemFrequency? frequency,
    List<DayOfWeek>? weeklyDays,
    List<int>? monthlyDates,
    int? repeatEvery,
    bool? isActive,
  }) {
    return RoutineDto(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      repeatDays: repeatDays ?? this.repeatDays,
      habits: habits ?? this.habits,
      frequency: frequency ?? this.frequency,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      monthlyDates: monthlyDates ?? this.monthlyDates,
      repeatEvery: repeatEvery ?? this.repeatEvery,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'start_date': startDate.millisecondsSinceEpoch,
      'start_time': {'hour': startTime.hour, 'minute': startTime.minute},
      'repeat_days': repeatDays,
      'habits': habits.map((x) => x.toMap()).toList(),
      'frequency': frequency.index,
      'weekly_days': weeklyDays.map((x) => x.index).toList(),
      'monthly_dates': monthlyDates,
      'repeat_every': repeatEvery,
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
      repeatDays: List<int>.from(map['repeat_days']),
      habits: List<HabitDto>.from(
        (map['habits'] as List).map(
          (x) => HabitDto.fromMap(x as Map<String, dynamic>),
        ),
      ),
      frequency: ItemFrequency.values[map['frequency'] as int],
      weeklyDays: List<DayOfWeek>.from(
        (map['weekly_days'] as List).map((x) => DayOfWeek.values[x as int]),
      ),
      monthlyDates: List<int>.from(map['monthly_dates']),
      repeatEvery: map['repeat_every'] as int,
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
      repeatDays: repeatDays,
      habits: habits.map((h) => h.toEntity()).toList(),
      frequency: frequency,
      weeklyDays: weeklyDays,
      monthlyDates: monthlyDates,
      repeatEvery: repeatEvery,
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
    repeatDays,
    habits,
    frequency,
    weeklyDays,
    monthlyDates,
    repeatEvery,
    isActive,
  ];
}
