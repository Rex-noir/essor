import 'package:mobile/core/domain/entities/routine_enitity.dart';

abstract class RoutineRepository {
  Future<List<RoutineEntity>> fetchRoutinesForDate(DateTime date);
}
