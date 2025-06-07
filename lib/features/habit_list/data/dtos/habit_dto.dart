// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:mobile/features/habit_list/domain/entities/habit_entity.dart';

class HabitDto with EquatableMixin {
  final String id;
  final String title;
  final String? description;
  //enum
  final HabitFrequency frequency;
  final DateTime startDate;
  //enum
  final List<DayOfWeek> weeklyDays;
  final List<int> monthlyDates;
  final int repeatEvery;
  final bool isActive;

  const HabitDto({
    required this.id,
    required this.title,
    this.description,
    required this.frequency,
    required this.startDate,
    this.weeklyDays = const [],
    this.monthlyDates = const [],
    this.repeatEvery = 1,
    this.isActive = true,
  });

  HabitDto copyWith({
    String? id,
    String? title,
    String? description,
    HabitFrequency? frequency,
    DateTime? startDate,
    List<DayOfWeek>? weeklyDays,
    List<int>? monthlyDates,
    int? repeatEvery,
    bool? isActive,
  }) {
    return HabitDto(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      monthlyDates: monthlyDates ?? this.monthlyDates,
      repeatEvery: repeatEvery ?? this.repeatEvery,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'frequency': frequency.index,
      'start_date': startDate.millisecondsSinceEpoch,
      'weekly_days': weeklyDays.map((x) => x.index).toList(),
      'monthly_dates': monthlyDates,
      'repeat_every': repeatEvery,
      'is_active': isActive,
    };
  }

  factory HabitDto.fromMap(Map<String, dynamic> map) {
    return HabitDto(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] != null
          ? map['description'] as String
          : null,
      frequency: HabitFrequency.values[map['frequency'] as int],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['start_date'] as int),
      weeklyDays: List<DayOfWeek>.from(
        (map['weekly_days'] as List<int>).map<DayOfWeek>(
          (x) => DayOfWeek.values[x],
        ),
      ),
      monthlyDates: List<int>.from((map['monthly_dates'] as List<int>)),
      repeatEvery: map['repeat_every'] as int,
      isActive: map['is_active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory HabitDto.fromJson(String source) =>
      HabitDto.fromMap(json.decode(source) as Map<String, dynamic>);

  HabitEntity toEntity() {
    return HabitEntity(
      id: id,
      title: title,
      frequency: frequency,
      description: description,
      isActive: isActive,
      repeatEvery: repeatEvery,
      monthlyDates: monthlyDates,
      weeklyDays: weeklyDays,
      startDate: startDate,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      title,
      description,
      frequency,
      startDate,
      weeklyDays,
      monthlyDates,
      repeatEvery,
      isActive,
    ];
  }
}
