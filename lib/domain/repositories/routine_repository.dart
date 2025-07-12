import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/models/routine_with_task_entries.dart';

abstract class RoutineRepository {
  Stream<List<RoutineModel>> fetchRoutinesForDate(DateTime date);

  Future<RoutineModel> insertNewRoutine(RoutineModel routine);

  Future<RoutineModel> updateRoutine(RoutineModel routine);

  Future<List<RoutineModel>> fetchActiveRoutines();

  Stream<List<RoutineWithTaskEntries>> fetchRoutinesWithTaskEntriesForDate(
    DateTime date,
  );
}
