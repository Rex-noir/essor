import 'package:mobile/domain/models/routine_model.dart';

abstract class RoutineRepository {
  Stream<List<RoutineModel>> fetchRoutinesForDate(DateTime date);

  Future<RoutineModel> insertNewRoutine(RoutineModel routine);

  Future<RoutineModel> updateRoutine(RoutineModel routine);

  Future<List<RoutineModel>> fetchActiveRoutines();
}
