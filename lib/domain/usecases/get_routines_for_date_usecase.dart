import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/repositories/routine_repository.dart';

class GetRoutinesForDateUsecase {
  final RoutineRepository _routineRepository;

  GetRoutinesForDateUsecase(this._routineRepository);

  Stream<List<RoutineModel>> call(DateTime date) {
    return _routineRepository.fetchRoutinesForDate(date);
  }
}
