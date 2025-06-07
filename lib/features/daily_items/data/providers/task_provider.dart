import 'package:mobile/features/daily_items/data/dtos/task_dto.dart';

abstract class TaskProvider {
  Future<List<TaskDto>> fetchTasksForDate(DateTime date);
}
