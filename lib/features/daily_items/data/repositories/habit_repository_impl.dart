import 'package:mobile/features/daily_items/data/providers/habit_local_provider.dart';
import 'package:mobile/features/daily_items/domain/entities/habit_entity.dart';
import 'package:mobile/features/daily_items/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitListRepository {
  final HabitProvider provider;
  HabitRepositoryImpl(this.provider);
  @override
  Future<List<HabitEntity>> fetchHabitsForDate(DateTime date) async {
    final habits = await provider.fetchHabitsForDate(date);

    return habits.map((t) => t.toEntity()).toList();
  }
}
