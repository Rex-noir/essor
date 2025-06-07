import 'package:mobile/features/daily_items/domain/entities/routine_enitity.dart';

abstract class RoutineListRepository {
  Future<List<RoutineEntity>> fetchRoutinesForDate(DateTime date);
}
