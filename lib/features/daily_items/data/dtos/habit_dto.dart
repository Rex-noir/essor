import 'dart:convert';

import 'package:mobile/features/daily_items/domain/entities/habit_entity.dart';
import 'package:mobile/features/daily_items/domain/entities/item_entity.dart';

class HabitDto extends ItemEntity {
  final ItemFrequency frequency;
  final DateTime startDate;
  final List<DayOfWeek> weeklyDays;
  final List<int> monthlyDates;
  final int repeatEvery;
  final bool isActive;

  const HabitDto({
    required super.id,
    required super.title,
    super.description,
    required super.iconIndex,
    required super.type,
    super.target,
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
    int? iconIndex,
    ItemType? type,
    int? target,
    ItemFrequency? frequency,
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
      iconIndex: iconIndex ?? this.iconIndex,
      type: type ?? this.type,
      target: target ?? this.target,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
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
      'description': description,
      'icon_index': iconIndex,
      'type': type.index,
      'target': target,
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
      id: map['id'],
      title: map['title'],
      description: map['description'],
      iconIndex: map['icon_index'],
      type: ItemType.values[map['type']],
      target: map['target'],
      frequency: ItemFrequency.values[map['frequency']],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['start_date']),
      weeklyDays: List<int>.from(
        map['weekly_days'],
      ).map((x) => DayOfWeek.values[x]).toList(),
      monthlyDates: List<int>.from(map['monthly_dates']),
      repeatEvery: map['repeat_every'],
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
      type: type,
      target: target,
      frequency: frequency,
      startDate: startDate,
      weeklyDays: weeklyDays,
      monthlyDates: monthlyDates,
      repeatEvery: repeatEvery,
      isActive: isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    iconIndex,
    type,
    target,
    frequency,
    startDate,
    weeklyDays,
    monthlyDates,
    repeatEvery,
    isActive,
  ];
}
