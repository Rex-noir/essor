import 'package:mobile/domain/entities/routine_enitity.dart';

abstract class RoutineRepository {
  Future<List<RoutineEntity>> fetchRoutinesForDate(DateTime date);
}
