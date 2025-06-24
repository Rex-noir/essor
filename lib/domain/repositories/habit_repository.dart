import 'package:mobile/domain/models/habit_model.dart';

abstract class HabitRepository {
  Future<List<HabitModel>> fetchHabitsForDate(DateTime date);
  Future<HabitModel> createHabit(HabitModel habit);
  Future<HabitModel> updateHabit(HabitModel habit);
}
