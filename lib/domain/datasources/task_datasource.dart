import 'package:mobile/data/dtos/task_dto.dart';

abstract class TaskDataSource {
  Future<List<TaskDto>> fetchTasksForDate(DateTime date);
}
