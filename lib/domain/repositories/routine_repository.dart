import 'package:mobile/domain/models/routine_model.dart';

abstract class RoutineRepository {
  Future<List<RoutineModel>> fetchRoutinesForDate(DateTime date);
}
