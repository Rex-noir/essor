import 'package:flutter/material.dart';
import 'package:mobile/domain/enums/habit_target_operator_enum.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/domain/enums/item_type.dart';
import 'package:mobile/infrastructure/notification/models/schedulable_model.dart';

class HabitModel extends Schedulable {
  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  final int iconIndex;
  @override
  final TimeOfDay startTime;

  @override
  final ItemFrequency frequency;
  @override
  final DateTime startDate;
  @override
  final List<int> weeklyDays;
  @override
  final List<int> monthlyDates;
  @override
  final int interval;
  final bool isActive;
  final ItemType habitType;
  final String? targetUnit;
  final int? targetValue;
  final TargetOperator targetOperator;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  @override
  final DateTime? lastScheduledAt;

  HabitModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconIndex,
    required this.frequency,
    required this.startDate,
    required this.weeklyDays,
    required this.monthlyDates,
    required this.interval,
    required this.isActive,
    required this.habitType,
    required this.targetUnit,
    required this.targetValue,
    required this.targetOperator,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.lastScheduledAt,
    required this.startTime,
  });

  HabitModel copyWith({
    String? id,
    String? title,
    String? description,
    int? iconIndex,
    TimeOfDay? startTime,
    ItemFrequency? frequency,
    DateTime? startDate,
    List<int>? weeklyDays,
    List<int>? monthlyDates,
    int? interval,
    bool? isActive,
    ItemType? habitType,
    String? targetUnit,
    int? targetValue,
    TargetOperator? targetOperator,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    DateTime? lastScheduledAt,
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconIndex: iconIndex ?? this.iconIndex,
      startTime: startTime ?? this.startTime,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      weeklyDays: weeklyDays ?? List.from(this.weeklyDays),
      monthlyDates: monthlyDates ?? List.from(this.monthlyDates),
      interval: interval ?? this.interval,
      isActive: isActive ?? this.isActive,
      habitType: habitType ?? this.habitType,
      targetUnit: targetUnit ?? this.targetUnit,
      targetValue: targetValue ?? this.targetValue,
      targetOperator: targetOperator ?? this.targetOperator,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastScheduledAt: lastScheduledAt ?? this.lastScheduledAt,
    );
  }
}
