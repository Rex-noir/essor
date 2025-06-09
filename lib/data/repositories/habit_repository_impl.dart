import 'package:mobile/domain/datasources/habit_datasource.dart';
import 'package:mobile/domain/entities/habit_entity.dart';
import 'package:mobile/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitListRepository {
  final HabitDataSource provider;
  HabitRepositoryImpl(this.provider);
  @override
  Future<List<HabitEntity>> fetchHabitsForDate(DateTime date) async {
    final habits = await provider.fetchHabitsForDate(date);

    return habits.map((t) => t.toEntity()).toList();
  }
}
