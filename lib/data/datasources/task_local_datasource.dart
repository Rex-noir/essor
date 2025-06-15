import 'package:mobile/data/dtos/task_dto.dart';
import 'package:mobile/domain/datasources/task_datasource.dart';

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
        duration: Duration(minutes: 30),
        isCompleted: false,
      ),
      TaskDto(
        id: 'task2',
        title: 'Team Meeting',
        description: 'Sprint planning with the dev team',
        iconIndex: 2,
        duration: Duration(minutes: 10),
        isCompleted: true,
      ),
      TaskDto(
        id: 'task3',
        title: 'Lunch with Sarah',
        description: 'Catch up over lunch at the new café',
        iconIndex: 3,
        duration: Duration(minutes: 14),
        isCompleted: false,
      ),
      TaskDto(
        id: 'task4',
        title: 'Read a book',
        description: 'Finish reading 3 chapters of “Atomic Habits”',
        iconIndex: 4,
        duration: Duration(minutes: 10),
        isCompleted: false,
      ),
    ];
  }
}
