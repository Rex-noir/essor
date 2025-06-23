import 'package:drift/drift.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/database/tables/routines_table.dart';
import 'package:mobile/domain/enums/item_frequency.dart';

part 'routines_dao.g.dart';

@DriftAccessor(tables: [RoutinesTable])
class RoutinesDao extends DatabaseAccessor<AppDatabase>
    with _$RoutinesDaoMixin {
  RoutinesDao(super.attachedDatabase);

  Future<List<Routine>> fetchAllActiveForDate(DateTime date) async {
    final allRoutines =
        await (select(routinesTable)..where(
              (tbl) =>
                  tbl.deletedAt.isNull() &
                  tbl.startDate.isSmallerOrEqualValue(date),
            ))
            .get();

    return allRoutines.where((routine) {
      final daysDifference = date.difference(routine.startDate).inDays;

      switch (routine.frequency) {
        case ItemFrequency.daily:
          return daysDifference % routine.interval == 0;

        case ItemFrequency.weekly:
          final weeksDifference = (daysDifference / 7).floor();
          return routine.weeklyDays.contains(date.weekday) &&
              weeksDifference % routine.interval == 0;

        case ItemFrequency.monthly:
          final isMatchingDay = routine.monthlyDates.contains(date.day);
          final monthDiff =
              (date.year - routine.startDate.year) * 12 +
              (date.month - routine.startDate.month);
          return isMatchingDay && monthDiff % routine.interval == 0;
      }
    }).toList();
  }

  Future<Routine> insertNewRoutine(RoutineCompanion routine) async {
    await into(routinesTable).insert(routine);
    return await (select(
      routinesTable,
    )..where((tbl) => tbl.id.equals(routine.id.value))).getSingle();
  }

  Future<Routine> updateRoutine(RoutineCompanion routine) async {
    await update(routinesTable).replace(routine);
    final newRoutine = await (select(
      routinesTable,
    )..where((tbl) => tbl.id.equals(routine.id.value))).getSingle();
    return newRoutine;
  }
}
