import 'package:mobile/features/daily_items/data/dtos/habit_dto.dart';

abstract class HabitListProvider {
  Future<List<HabitDto>> fetchHabitsForDate(DateTime date);
}
