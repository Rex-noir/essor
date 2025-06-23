import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/repositories/routine_repository.dart';

class UpdateRoutineUsecase {
  final RoutineRepository _repository;
  UpdateRoutineUsecase(this._repository);

  Future<RoutineModel> call(RoutineModel model) {
    return _repository.updateRoutine(model);
  }
}
