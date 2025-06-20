import 'package:mobile/domain/models/habit_model.dart';

abstract class HabitRepository {
  Future<List<HabitModel>> fetchHabitsForDate(DateTime date);
}
