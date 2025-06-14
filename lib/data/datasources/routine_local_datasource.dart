import 'package:flutter/material.dart';
import 'package:mobile/data/dtos/routine_dto.dart';
import 'package:mobile/data/dtos/task_dto.dart';
import 'package:mobile/domain/datasources/routine_datasource.dart';
import 'package:mobile/domain/entities/habit_entity.dart';
import 'package:mobile/domain/entities/item_entity.dart';
import 'package:mobile/domain/enums/day_of_week.dart'; // Import ItemType

class RoutineLocalDataSource implements RoutineDataSource {
  @override
  Future<List<RoutineDto>> fetchRoutinesForDate(DateTime date) async {
    return List.generate(10, (i) {
      final now = date.subtract(Duration(days: i));
      final startTime = TimeOfDay(hour: 6 + (i % 4), minute: 15 * (i % 3));

      final tasks = List.generate(3 + (i % 2), (j) {
        return TaskDto(
          id: 'task_${i}_$j', // Added id
          title: 'Task ${i + 1}.${j + 1}',
          description: 'Auto-generated task for routine ${i + 1}',
          startDate: now,
          startTime: TimeOfDay(hour: 8 + (j % 4), minute: 10 * j),
          isCompleted: j % 2 == 0,
          iconIndex: j,
          type: ItemType.binary,
        );
      });

      return RoutineDto(
        id: 'routine_$i',
        title: 'Routine ${i + 1}',
        startDate: now,
        startTime: startTime,
        tasks: tasks,
        frequency: ItemFrequency.weekly,
        weeklyDays: [DayOfWeek.monday, DayOfWeek.wednesday],
        monthlyDates: [1, 15],
        interval: 1,
        isActive: true,
      );
    });
  }
}
