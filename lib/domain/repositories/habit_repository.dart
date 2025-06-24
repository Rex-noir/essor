import 'package:mobile/domain/models/habit_model.dart';

abstract class HabitRepository {
  Stream<List<HabitModel>> fetchHabitsForDate(DateTime date);
  Future<HabitModel> createHabit(HabitModel habit);
  Future<HabitModel> updateHabit(HabitModel habit);
}
