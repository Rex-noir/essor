import 'package:mobile/core/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> fetchTasksforDate(DateTime date);
}
