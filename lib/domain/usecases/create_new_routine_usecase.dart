import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/repositories/routine_repository.dart';

class CreateNewRoutineUsecase {
  final RoutineRepository _routineRepository;

  CreateNewRoutineUsecase(this._routineRepository);
  Future<RoutineModel> call(RoutineModel routine) {
    return _routineRepository.insertNewRoutine(routine);
  }
}
