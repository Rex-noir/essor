import 'package:drift/drift.dart';
import 'package:mobile/database/daos/habits_dao.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/database/tables/habits_table.dart';
import 'package:mobile/domain/models/habit_model.dart';
import 'package:mobile/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitsDao _habitsDao;
  HabitRepositoryImpl({required HabitsDao habitsDao}) : _habitsDao = habitsDao;
  @override
  Future<List<HabitModel>> fetchHabitsForDate(DateTime date) async {
    final habits = await _habitsDao.getHabitsForDate(date);
    return habits.map((t) => t.toModel()).toList();
  }

  @override
  Future<HabitModel> createHabit(HabitModel habit) async {
    final companion = HabitCompanion.insert(
      id: habit.id,
      title: habit.title,
      description: Value(habit.description),
      iconIndex: habit.iconIndex,
      frequency: habit.frequency,
      startDate: habit.startDate,
      weeklyDays: Value(habit.weeklyDays),
      startTime: habit.startTime,
      monthlyDates: Value(habit.monthlyDates),
      interval: Value(habit.interval),
      isActive: Value(habit.isActive),
      habitType: habit.habitType,
      targetUnit: Value(habit.targetUnit),
      targetValue: Value(habit.targetValue),
      targetOperator: Value(habit.targetOperator),
    );
    final created = await _habitsDao.insertHabit(companion);
    return created.toModel();
  }

  @override
  Future<HabitModel> updateHabit(HabitModel habit) async {
    final companion = HabitCompanion(
      id: Value(habit.id),
      title: Value(habit.title),
      description: Value(habit.description),
      iconIndex: Value(habit.iconIndex),
      frequency: Value(habit.frequency),
      startDate: Value(habit.startDate),
      weeklyDays: Value(habit.weeklyDays),
      startTime: Value(habit.startTime),
      monthlyDates: Value(habit.monthlyDates),
      interval: Value(habit.interval),
      isActive: Value(habit.isActive),
      habitType: Value(habit.habitType),
      targetUnit: Value(habit.targetUnit),
      targetValue: Value(habit.targetValue),
      targetOperator: Value(habit.targetOperator),
      updatedAt: Value(DateTime.now()),
    );

    final updatedHabit = await _habitsDao.updateHabit(companion);
    return updatedHabit.toModel();
  }
}
