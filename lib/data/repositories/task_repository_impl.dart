import 'package:mobile/domain/datasources/task_datasource.dart';
import 'package:mobile/domain/entities/task_entity.dart';
import 'package:mobile/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDataSource _provider;
  TaskRepositoryImpl(TaskDataSource provider) : _provider = provider;
  @override
  Future<List<TaskEntity>> fetchTasksforDate(DateTime date) async {
    final tasks = await _provider.fetchTasksForDate(date);
    return tasks.map((e) => e.toEntity()).toList();
  }
}
