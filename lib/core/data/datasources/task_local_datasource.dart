import 'package:flutter/material.dart';
import 'package:mobile/core/data/dtos/task_dto.dart';
import 'package:mobile/core/domain/datasources/task_datasource.dart';
import 'package:mobile/core/domain/entities/item_entity.dart';

class TaskLocalDataSource implements TaskDataSource {
  @override
  Future<List<TaskDto>> fetchTasksForDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return [
      TaskDto(
        id: 'task1',
        title: 'Morning Workout',
        description: '30 mins of cardio and strength training',
        iconIndex: 1,
        type: ItemType.quantitative,
        target: 1,
        startDate: date,
        startTime: const TimeOfDay(hour: 6, minute: 30),
        isCompleted: false,
      ),
      TaskDto(
        id: 'task2',
        title: 'Team Meeting',
        description: 'Sprint planning with the dev team',
        iconIndex: 2,
        type: ItemType.binary,
        target: null,
        startDate: date,
        startTime: const TimeOfDay(hour: 10, minute: 0),
        isCompleted: true,
      ),
      TaskDto(
        id: 'task3',
        title: 'Lunch with Sarah',
        description: 'Catch up over lunch at the new café',
        iconIndex: 3,
        type: ItemType.binary,
        target: null,
        startDate: date,
        startTime: const TimeOfDay(hour: 13, minute: 15),
        isCompleted: false,
      ),
      TaskDto(
        id: 'task4',
        title: 'Read a book',
        description: 'Finish reading 3 chapters of “Atomic Habits”',
        iconIndex: 4,
        type: ItemType.quantitative,
        target: 3,
        startDate: date,
        startTime: const TimeOfDay(hour: 20, minute: 0),
        isCompleted: false,
      ),
    ];
  }
}
