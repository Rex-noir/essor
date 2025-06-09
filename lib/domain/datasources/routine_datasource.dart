import 'package:mobile/data/dtos/routine_dto.dart';

abstract class RoutineDataSource {
  Future<List<RoutineDto>> fetchRoutinesForDate(DateTime date);
}
