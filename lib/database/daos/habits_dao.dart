import 'package:drift/drift.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/database/tables/habits_table.dart';
import 'package:mobile/domain/enums/item_frequency.dart';

part 'habits_dao.g.dart';

@DriftAccessor(tables: [HabitsTable])
class HabitsDao extends DatabaseAccessor<AppDatabase> with _$HabitsDaoMixin {
  HabitsDao(super.attachedDatabase);

  Future<List<Habit>> getHabitsForDate(DateTime date) async {
    final allHabits =
        await (select(habitsTable)..where(
              (tbl) =>
                  tbl.isActive.equals(true) &
                  tbl.deletedAt.isNull() &
                  tbl.startDate.isSmallerOrEqualValue(date),
            ))
            .get();

    return allHabits.where((habit) {
      final daysDifference = date.difference(habit.startDate).inDays;

      switch (habit.frequency) {
        case ItemFrequency.daily:
          return daysDifference % habit.interval == 0;

        case ItemFrequency.weekly:
          final weeksDifference = (daysDifference / 7).floor();
          return habit.weeklyDays.contains(date.weekday) &&
              weeksDifference % habit.interval == 0;

        case ItemFrequency.monthly:
          final isMatchingDay = habit.monthlyDates.contains(date.day);
          final monthDiff =
              (date.year - habit.startDate.year) * 12 +
              (date.month - habit.startDate.month);
          return isMatchingDay && monthDiff % habit.interval == 0;
      }
    }).toList();
  }

  Future<Habit> insertHabit(HabitCompanion habit) async {
    await into(habitsTable).insert(habit); // does not return ID

    final insertedHabit = await (select(
      habitsTable,
    )..where((tbl) => tbl.id.equals(habit.id.value))).getSingle();

    return insertedHabit;
  }
}
