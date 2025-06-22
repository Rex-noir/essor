import 'package:mobile/domain/models/task_with_entry_model.dart';
import 'package:mobile/domain/repositories/task_repository.dart';

class CreateNewTaskUsecase {
  final TaskRepository _repo;
  const CreateNewTaskUsecase(this._repo);

  Future<TaskWithEntryModel> call(TaskWithEntryModel task, DateTime date) {
    return _repo.createNewTask(task, date);
  }
}
