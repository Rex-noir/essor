import 'package:mobile/domain/models/task_model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> fetchTasksforDate(DateTime date);
}
