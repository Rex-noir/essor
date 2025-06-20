import 'package:mobile/database/daos/routines_dao.dart';
import 'package:mobile/database/tables/routines_table.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/repositories/routine_repository.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final RoutinesDao _routinesDao;

  RoutineRepositoryImpl(this._routinesDao);

  @override
  Future<List<RoutineModel>> fetchRoutinesForDate(DateTime date) async {
    final routines = await _routinesDao.fetchAllActiveBeforeDate(date);

    return routines.map((t) => t.toModel()).toList();
  }
}
