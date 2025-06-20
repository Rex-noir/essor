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

    final weekday = date.weekday;
    final dayOfMonth = date.day;

    return allHabits.where((habit) {
      switch (habit.frequency) {
        case ItemFrequency.daily:
          return true;
        case ItemFrequency.weekly:
          return habit.weeklyDays.contains(weekday);
        case ItemFrequency.monthly:
          return habit.monthlyDates.contains(dayOfMonth);
      }
    }).toList();
  }

  Future<Habit> insertHabit(HabitsTableCompanion habit) async {
    await into(habitsTable).insert(habit); // does not return ID

    final insertedHabit = await (select(
      habitsTable,
    )..where((tbl) => tbl.id.equals(habit.id.value))).getSingle();

    return insertedHabit;
  }
}
