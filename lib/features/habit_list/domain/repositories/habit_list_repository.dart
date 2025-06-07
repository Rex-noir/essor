import 'package:mobile/features/habit_list/domain/entities/habit_entity.dart';

abstract class HabitListRepository {
  Future<List<HabitEntity>> fetchHabitsForDate(DateTime date);
}
