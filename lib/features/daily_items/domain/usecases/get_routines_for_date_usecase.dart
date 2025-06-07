import 'package:mobile/features/daily_items/domain/entities/routine_enitity.dart';
import 'package:mobile/features/daily_items/domain/repositories/routine_repository.dart';

class GetRoutinesForDateUsecase {
  final RoutineRepository _routineRepository;

  GetRoutinesForDateUsecase(this._routineRepository);

  Future<List<RoutineEntity>> call(DateTime date) {
    return _routineRepository.fetchRoutinesForDate(date);
  }
}
