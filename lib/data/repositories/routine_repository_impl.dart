import 'package:drift/drift.dart';
import 'package:mobile/database/daos/routines_dao.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/database/tables/routines_table.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/repositories/routine_repository.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final RoutinesDao _routinesDao;

  RoutineRepositoryImpl(this._routinesDao);

  @override
  Stream<List<RoutineModel>> fetchRoutinesForDate(DateTime date) {
    return _routinesDao.fetchAllActiveForDate(date).map((listOfRoutinesFromDb) {
      return listOfRoutinesFromDb
          .map((dbRoutine) => dbRoutine.toModel())
          .toList();
    });
  }

  @override
  Future<RoutineModel> insertNewRoutine(RoutineModel routine) async {
    final companion = RoutineCompanion.insert(
      id: routine.id,
      title: routine.title,
      startDate: routine.startDate,
      startTime: routine.startTime,
      frequency: routine.frequency,
      weeklyDays: Value(routine.weeklyDays),
      monthlyDates: Value(routine.monthlyDates),
      iconIndex: Value(routine.iconIndex),
      isShared: Value(routine.isShared),
      interval: Value(routine.interval),
    );
    final inserted = await _routinesDao.insertNewRoutine(companion);
    return inserted.toModel();
  }

  @override
  Future<RoutineModel> updateRoutine(RoutineModel routine) async {
    final updated = await _routinesDao.updateRoutine(
      RoutineCompanion(
        id: Value(routine.id),
        title: Value(routine.title),
        startDate: Value(routine.startDate),
        startTime: Value(routine.startTime),
        frequency: Value(routine.frequency),
        interval: Value(routine.interval),
        updatedAt: Value(DateTime.now()),
        weeklyDays: Value(routine.weeklyDays),
        monthlyDates: Value(routine.monthlyDates),
        iconIndex: Value(routine.iconIndex),
      ),
    );
    return updated.toModel();
  }

  @override
  Stream<List<RoutineModel>> fetchActiveRoutines(RoutineModel routine) {
    return _routinesDao.watchActiveRoutines().map(
      (listOfRoutinesFromDb) =>
          listOfRoutinesFromDb.map((e) => e.toModel()).toList(),
    );
  }
}
