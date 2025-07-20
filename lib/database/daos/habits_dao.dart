import 'package:drift/drift.dart';
import 'package:mobile/data/dto/habit_with_entry_dto.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/database/tables/habit_entries_table.dart';
import 'package:mobile/database/tables/habits_table.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:rxdart/rxdart.dart';

part 'habits_dao.g.dart';

@DriftAccessor(tables: [HabitsTable, HabitEntriesTable])
class HabitsDao extends DatabaseAccessor<AppDatabase> with _$HabitsDaoMixin {
  HabitsDao(super.attachedDatabase);

  Stream<List<Habit>> getHabitsForDate(DateTime date) {
    return (select(habitsTable)..where(
          (tbl) =>
              tbl.isActive.equals(true) &
              tbl.deletedAt.isNull() &
              tbl.startDate.isSmallerOrEqualValue(date),
        ))
        .watch() // Use .watch() to get a stream
        .map((allHabits) {
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
        });
  }

  Future<Habit> insertHabit(HabitCompanion habit) async {
    await into(habitsTable).insert(habit); // does not return ID

    final insertedHabit = await (select(
      habitsTable,
    )..where((tbl) => tbl.id.equals(habit.id.value))).getSingle();

    return insertedHabit;
  }

  Stream<List<HabitWithEntryDto>> watchHabitsWithEntryForDate(DateTime date) {
    final habitsStream = getHabitsForDate(date);
    final entriesStream = (select(
      habitEntriesTable,
    )..where((tbl) => tbl.entryDate.equals(date))).watch();

    return Rx.combineLatest2(habitsStream, entriesStream, (
      List<Habit> habits,
      List<HabitEntry> entries,
    ) {
      final entryMap = {for (final e in entries) e.habitId: e};

      return habits.map((habit) {
        final entry = entryMap[habit.id];
        return HabitWithEntryDto(habit: habit, entry: entry);
      }).toList();
    });
  }

  Future<Habit> updateHabit(HabitCompanion habit) async {
    await into(habitsTable).insertOnConflictUpdate(habit);
    final updatedHabit = await (select(
      habitsTable,
    )..where((tbl) => tbl.id.equals(habit.id.value))).getSingle();

    return updatedHabit;
  }

  Future<void> upsertEntry(HabitEntryCompanion data) async {
    await into(habitEntriesTable).insertOnConflictUpdate(data);
  }
}
