// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mobile/domain/entities/item_entity.dart';

enum ItemFrequency { daily, weekly, monthly }

class HabitEntity extends ItemEntity {
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

  @override
  const HabitEntity({
    required super.id,
    required super.title,
    super.description,
    required this.habitType,
    this.targetUnit,
    required this.targetValue,
    required super.iconIndex,
    required this.frequency,
    required this.startDate,
    this.weeklyDays = const [],
    this.monthlyDates = const [],
    this.targetOperator = '=',
    this.interval = 1,
    this.isActive = true,
  });

  HabitEntity copyWith({
    String? id,
    String? title,
    String? description,
    ItemType? habitType,
    int? targetValue,
    ItemFrequency? frequency,
    DateTime? startDate,
    List<int>? weeklyDays,
    List<int>? monthlyDates,
    int? interval,
    bool? isActive,
    String? targetUnit,
    String? targetOperator,
    int? iconIndex,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      habitType: habitType ?? this.habitType,
      targetValue: targetValue ?? this.targetValue,
      targetUnit: targetUnit ?? this.targetUnit,
      targetOperator: targetOperator ?? this.targetOperator,
      iconIndex: iconIndex ?? this.iconIndex,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      monthlyDates: monthlyDates ?? this.monthlyDates,
      interval: interval ?? this.interval,
      isActive: isActive ?? this.isActive,
    );
  }
}
