import 'package:mobile/features/daily_items/data/providers/routine_provider.dart';
import 'package:mobile/features/daily_items/domain/entities/routine_enitity.dart';
import 'package:mobile/features/daily_items/domain/repositories/routine_repository.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineProvider provider;
  RoutineRepositoryImpl(this.provider);
  @override
  Future<List<RoutineEntity>> fetchRoutinesForDate(DateTime date) async {
    final routines = await provider.fetchRoutinesForDate(date);
    return routines.map((e) => e.toEntity()).toList();
  }
}
