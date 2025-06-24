import 'package:flutter/material.dart';
import 'package:mobile/domain/enums/habit_target_operator_enum.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/domain/enums/item_type.dart';

class HabitModel {
  final String id;
  final String title;
  final String? description;
  final int iconIndex;
  final TimeOfDay startTime;

  final ItemFrequency frequency;
  final DateTime startDate;
  final List<int> weeklyDays;
  final List<int> monthlyDates;
  final int interval;
  final bool isActive;
  final ItemType habitType;
  final String? targetUnit;
  final int? targetValue;
  final TargetOperator targetOperator;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

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
    required this.startTime,
  });
}
