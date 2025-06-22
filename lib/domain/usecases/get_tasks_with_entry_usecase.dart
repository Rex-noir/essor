import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/models/task_with_entry_model.dart';
import 'package:mobile/domain/repositories/task_repository.dart';

class GetTasksWithEntryUsecase {
  final TaskRepository _taskRepository;
  const GetTasksWithEntryUsecase(this._taskRepository);

  Future<List<TaskWithEntryModel>> call(RoutineModel routine, DateTime date) {
    return _taskRepository.fetchTasksForRoutine(routine, date);
  }
}
