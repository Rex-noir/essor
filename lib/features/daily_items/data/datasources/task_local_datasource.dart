import 'package:flutter/material.dart';
import 'package:mobile/features/daily_items/data/dtos/task_dto.dart';
import 'package:mobile/features/daily_items/domain/datasources/task_datasource.dart';

class TaskLocalDataSource implements TaskDataSource {
  @override
  Future<List<TaskDto>> fetchTasksForDate(DateTime date) async {
    // Simulate async delay
    await Future.delayed(const Duration(milliseconds: 200));

    return [
      TaskDto(
        title: 'Morning Workout',
        description: '30 mins of cardio and strength training',
        startDate: date,
        startTime: const TimeOfDay(hour: 6, minute: 30),
        isCompleted: false,
        importance: 3,
      ),
      TaskDto(
        title: 'Team Meeting',
        description: 'Sprint planning with the dev team',
        startDate: date,
        startTime: const TimeOfDay(hour: 10, minute: 0),
        isCompleted: true,
        importance: 2,
      ),
      TaskDto(
        title: 'Lunch with Sarah',
        description: 'Catch up over lunch at the new café',
        startDate: date,
        startTime: const TimeOfDay(hour: 13, minute: 15),
        isCompleted: false,
        importance: 1,
      ),
      TaskDto(
        title: 'Read a book',
        description: 'Finish reading 3 chapters of “Atomic Habits”',
        startDate: date,
        startTime: const TimeOfDay(hour: 20, minute: 0),
        isCompleted: false,
        importance: 2,
      ),
    ];
  }
}
