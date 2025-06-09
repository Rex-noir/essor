import 'package:mobile/data/dtos/habit_dto.dart';

abstract class HabitDataSource {
  Future<List<HabitDto>> fetchHabitsForDate(DateTime date);
}
