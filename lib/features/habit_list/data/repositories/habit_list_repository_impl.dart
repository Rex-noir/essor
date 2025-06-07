import 'package:mobile/features/habit_list/data/providers/habit_list_provider.dart';
import 'package:mobile/features/habit_list/domain/entities/habit_entity.dart';
import 'package:mobile/features/habit_list/domain/repositories/habit_list_repository.dart';

class HabitListRepositoryImpl implements HabitListRepository {
  final HabitListProvider habitListProvider;
  HabitListRepositoryImpl(this.habitListProvider);
  @override
  Future<List<HabitEntity>> fetchHabitsForDate(DateTime date) async {
    final habits = await habitListProvider.fetchHabitsForDate(date);

    return habits.map((t) => t.toEntity()).toList();
  }
}
