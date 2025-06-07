import 'package:mobile/features/daily_items/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> fetchTasksforDate(DateTime date);
}
