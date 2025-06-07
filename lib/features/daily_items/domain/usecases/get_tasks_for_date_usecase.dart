import 'package:mobile/features/daily_items/domain/entities/task_entity.dart';
import 'package:mobile/features/daily_items/domain/repositories/task_repository.dart';

class GetTasksForDateUsecase {
  final TaskRepository repository;

  GetTasksForDateUsecase(this.repository);

  Future<List<TaskEntity>> call(DateTime date) {
    return repository.fetchTasksforDate(date);
  }
}
