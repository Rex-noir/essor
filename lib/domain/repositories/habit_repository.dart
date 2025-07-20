import 'package:mobile/domain/models/habit_entry_model.dart';
import 'package:mobile/domain/models/habit_model.dart';
import 'package:mobile/domain/models/habit_with_entry_model.dart';

abstract class HabitRepository {
  Stream<List<HabitModel>> fetchHabitsForDate(DateTime date);

  Future<HabitModel> createHabit(HabitModel habit);

  Future<HabitModel> updateHabit(HabitModel habit);

  Stream<List<HabitWithEntryModel>> fetchHabitsWithEntryForDate(DateTime date);

  Future<void> upsertEntry(HabitEntryModel entry);
}
