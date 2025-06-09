import 'package:mobile/domain/datasources/routine_datasource.dart';
import 'package:mobile/domain/entities/routine_enitity.dart';
import 'package:mobile/domain/repositories/routine_repository.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineDataSource provider;
  RoutineRepositoryImpl(this.provider);
  @override
  Future<List<RoutineEntity>> fetchRoutinesForDate(DateTime date) async {
    final routines = await provider.fetchRoutinesForDate(date);
    return routines.map((e) => e.toEntity()).toList();
  }
}
