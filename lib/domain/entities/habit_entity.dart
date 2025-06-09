// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mobile/domain/entities/item_entity.dart';

import '../enums/day_of_week.dart';

enum ItemFrequency { daily, weekly, monthly }

class HabitEntity extends ItemEntity {
  final ItemFrequency frequency;
  final DateTime startDate;
  final List<DayOfWeek> weeklyDays;
  final List<int> monthlyDates;
  final int repeatEvery;
  final bool isActive;

  const HabitEntity({
    required super.id,
    required super.title,
    super.description,
    super.duration,
    required super.type,
    super.unit,
    super.target,
    required super.iconIndex,
    required this.frequency,
    required this.startDate,
    this.weeklyDays = const [],
    this.monthlyDates = const [],
    this.repeatEvery = 1,
    this.isActive = true,
  });

  HabitEntity copyWith({
    String? id,
    String? title,
    String? description,
    ItemType? type,
    int? target,
    ItemFrequency? frequency,
    DateTime? startDate,
    List<DayOfWeek>? weeklyDays,
    List<int>? monthlyDates,
    int? repeatEvery,
    bool? isActive,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      target: target ?? this.target,
      iconIndex: iconIndex,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      monthlyDates: monthlyDates ?? this.monthlyDates,
      repeatEvery: repeatEvery ?? this.repeatEvery,
      isActive: isActive ?? this.isActive,
    );
  }
}
