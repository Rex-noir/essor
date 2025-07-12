import 'package:drift/drift.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/database/tables/routines_table.dart';
import 'package:mobile/database/tables/task_entries_table.dart';
import 'package:mobile/database/tables/tasks_table.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/domain/models/routine_with_task_entries.dart';
import 'package:mobile/domain/models/task_with_entry_model.dart';
import 'package:rxdart/rxdart.dart';

part 'routines_dao.g.dart';

@DriftAccessor(tables: [RoutinesTable, TasksTable, TaskEntriesTable])
class RoutinesDao extends DatabaseAccessor<AppDatabase>
    with _$RoutinesDaoMixin {
  RoutinesDao(super.attachedDatabase);

  Stream<List<Routine>> fetchAllActiveForDate(DateTime date) {
    return (select(routinesTable)..where(
          (tbl) =>
              tbl.deletedAt.isNull() &
              tbl.startDate.isSmallerOrEqualValue(date),
        ))
        .watch() // Use .watch() to get a stream
        .map((allRoutines) {
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
        });
  }

  Future<Routine> insertNewRoutine(RoutineCompanion routine) async {
    await into(routinesTable).insert(routine);
    return await (select(
      routinesTable,
    )..where((tbl) => tbl.id.equals(routine.id.value))).getSingle();
  }

  Future<List<Routine>> getActiveRoutines() {
    return (select(
      routinesTable,
    )..where((tbl) => tbl.deletedAt.isNull())).get();
  }

  Future<Routine> updateRoutine(RoutineCompanion routine) async {
    await update(routinesTable).replace(routine);
    final newRoutine = await (select(
      routinesTable,
    )..where((tbl) => tbl.id.equals(routine.id.value))).getSingle();
    return newRoutine;
  }

  Stream<List<RoutineWithTaskEntries>> watchRoutineWithTaskEntriesForDate(
    DateTime date,
  ) {
    final routinesStream = fetchAllActiveForDate(date);
    final tasksStream = select(tasksTable).watch();
    final taskEntriesStream = (select(
      taskEntriesTable,
    )..where((tbl) => tbl.entryDate.equals(date))).watch();

    return Rx.combineLatest3<
      List<Routine>,
      List<Task>,
      List<TaskEntry>,
      List<RoutineWithTaskEntries>
    >(routinesStream, tasksStream, taskEntriesStream, (
      routines,
      tasks,
      entries,
    ) {
      return routines.map((routine) {
        // Get tasks for this routine
        final relatedTasks = tasks
            .where((task) => task.routineId == routine.id)
            .toList();

        // Map task entries by taskId
        final Map<String, TaskEntry> entryMap = {
          for (final entry in entries) entry.taskId: entry,
        };

        // Attach each task with its corresponding entry (if any)
        final taskWithEntries = relatedTasks.map((task) {
          final entry = entryMap[task.id];
          return TaskWithEntryModel(
            task: task.toModel(),
            entry: entry?.toModel(),
          );
        }).toList();

        return RoutineWithTaskEntries(
          routine: routine.toModel(),
          tasks: taskWithEntries,
        );
      }).toList();
    });
  }
}
