import 'package:flutter/material.dart';
import 'package:mobile/features/daily_items/data/dtos/habit_dto.dart';
import 'package:mobile/features/daily_items/data/dtos/routine_dto.dart';
import 'package:mobile/features/daily_items/data/providers/routine_provider.dart';
import 'package:mobile/features/daily_items/domain/entities/habit_entity.dart';

class RoutineLocalProvider implements RoutineProvider {
  @override
  Future<List<RoutineDto>> fetchRoutinesForDate(DateTime date) async {
    return List.generate(15, (i) {
      final now = DateTime.now().subtract(Duration(days: i));
      final time = TimeOfDay(hour: 6 + (i % 5), minute: 15 * (i % 4));
      final habits = List.generate(2 + (i % 3), (j) {
        return HabitDto(
          id: 'habit_${i}_$j',
          title: 'Habit ${i * 3 + j + 1}',
          description: 'Auto-generated habit',
          frequency: ItemFrequency.daily,
          startDate: now,
          weeklyDays: [DayOfWeek.monday, DayOfWeek.wednesday],
          monthlyDates: [1, 15],
          repeatEvery: 1,
          isActive: true,
        );
      });

      return RoutineDto(
        id: 'routine_$i',
        title: 'Routine ${i + 1}',
        startDate: now,
        startTime: time,
        repeatDays: [1, 3, 5], // Monday, Wednesday, Friday
        habits: habits,
        frequency: ItemFrequency.weekly,
        weeklyDays: [DayOfWeek.monday, DayOfWeek.wednesday],
        monthlyDates: [1, 15],
        repeatEvery: 1,
        isActive: true,
      );
    });
  }
}
