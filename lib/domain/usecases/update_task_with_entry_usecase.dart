import 'package:mobile/domain/models/task_with_entry_model.dart';
import 'package:mobile/domain/repositories/task_repository.dart';

class UpdateTaskWithEntryUsecase {
  final TaskRepository _repository;
  const UpdateTaskWithEntryUsecase(this._repository);

  Future<TaskWithEntryModel> call(TaskWithEntryModel model) {
    return _repository.updateTask(model);
  }
}
