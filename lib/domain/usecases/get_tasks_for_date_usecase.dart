import 'package:mobile/domain/models/task_model.dart';
import 'package:mobile/domain/repositories/task_repository.dart';

class GetTasksForDateUsecase {
  final TaskRepository repository;

  GetTasksForDateUsecase(this.repository);

  Future<List<TaskModel>> call(DateTime date) {
    return repository.fetchTasksforDate(date);
  }
}
