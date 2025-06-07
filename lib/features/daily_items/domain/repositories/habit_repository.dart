import 'package:mobile/features/daily_items/domain/entities/habit_entity.dart';

abstract class HabitListRepository {
  Future<List<HabitEntity>> fetchHabitsForDate(DateTime date);
}
