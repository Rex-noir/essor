import 'package:mobile/features/habit_list/data/dtos/habit_dto.dart';

abstract class HabitListProvider {
  Future<List<HabitDto>> fetchHabitsForDate(DateTime date);
}
