import 'package:mobile/core/data/dtos/task_dto.dart';

abstract class TaskDataSource {
  Future<List<TaskDto>> fetchTasksForDate(DateTime date);
}
