// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mobile/domain/entities/habit_entity.dart';
import 'package:mobile/domain/entities/item_entity.dart';

class HabitDto extends ItemEntity {
  final ItemFrequency frequency;
  final DateTime startDate;
  final List<int> weeklyDays;
  final List<int> monthlyDates;
  final int interval;
  final bool isActive;
  final ItemType habitType;
  final String? targetUnit;
  final int? targetValue;
  final String targetOperator;

  const HabitDto({
    required super.id,
    required super.title,
    super.description,
    required super.iconIndex,
    required this.habitType,
    this.targetValue,
    required this.frequency,
    this.targetUnit,
    required this.startDate,
    this.weeklyDays = const [],
    this.monthlyDates = const [],
    this.targetOperator = '=',
    this.interval = 1,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_index': iconIndex,
      'habitType': habitType.index,
      'targetValue': targetValue,
      'frequency': frequency.index,
      'start_date': startDate.millisecondsSinceEpoch,
      'weekly_days': weeklyDays,
      'monthly_dates': monthlyDates,
      'interval': interval,
      'is_active': isActive,
    };
  }

  factory HabitDto.fromMap(Map<String, dynamic> map) {
    return HabitDto(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      iconIndex: map['icon_index'],
      habitType: ItemType.values[map['habitType']],
      targetValue: map['targetValue'],
      frequency: ItemFrequency.values[map['frequency']],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['start_date']),
      weeklyDays: List<int>.from(map['weekly_days']),
      monthlyDates: List<int>.from(map['monthly_dates']),
      interval: map['interval'],
      isActive: map['is_active'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HabitDto.fromJson(String source) =>
      HabitDto.fromMap(json.decode(source));

  HabitEntity toEntity() {
    return HabitEntity(
      id: id,
      title: title,
      description: description,
      iconIndex: iconIndex,
      habitType: habitType,
      targetValue: targetValue,
      frequency: frequency,
      startDate: startDate,
      weeklyDays: weeklyDays,
      monthlyDates: monthlyDates,
      interval: interval,
      isActive: isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    iconIndex,
    habitType,
    targetValue,
    frequency,
    startDate,
    weeklyDays,
    monthlyDates,
    interval,
    isActive,
  ];

  HabitDto copyWith({
    ItemFrequency? frequency,
    DateTime? startDate,
    List<int>? weeklyDays,
    List<int>? monthlyDates,
    int? interval,
    bool? isActive,
    ItemType? habitType,
    String? targetUnit,
    int? targetValue,
    String? targetOperator,
    int? iconIndex,
    String? description,
    String? id,
    String? title,
  }) {
    return HabitDto(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconIndex: iconIndex ?? this.iconIndex,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      monthlyDates: monthlyDates ?? this.monthlyDates,
      interval: interval ?? this.interval,
      isActive: isActive ?? this.isActive,
      habitType: habitType ?? this.habitType,
      targetUnit: targetUnit ?? this.targetUnit,
      targetValue: targetValue ?? this.targetValue,
      targetOperator: targetOperator ?? this.targetOperator,
    );
  }
}
