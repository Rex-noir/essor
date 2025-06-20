import 'package:mobile/database/daos/habits_dao.dart';
import 'package:mobile/database/tables/habits_table.dart';
import 'package:mobile/domain/models/habit_model.dart';
import 'package:mobile/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  HabitsDao habitsDao;
  HabitRepositoryImpl({required this.habitsDao});
  @override
  Future<List<HabitModel>> fetchHabitsForDate(DateTime date) async {
    final habits = await habitsDao.getHabitsForDate(date);
    return habits.map((t) => t.toModel()).toList();
  }
}
