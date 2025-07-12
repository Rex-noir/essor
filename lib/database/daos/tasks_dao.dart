import 'package:drift/drift.dart';
import 'package:mobile/core/extensions/date_extensions.dart';
import 'package:mobile/data/dto/task_with_entry_dto.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/database/tables/task_entries_table.dart';
import 'package:mobile/database/tables/tasks_table.dart';
import 'package:mobile/domain/models/task_model.dart';
import 'package:uuid/v4.dart';

part "tasks_dao.g.dart";

@DriftAccessor(tables: [TasksTable, TaskEntriesTable])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.attachedDatabase);

  Future<List<TaskWithEntryDto>> fetchTasksWithEntry(
    RoutineCompanion routine,
    DateTime date,
  ) async {
    final query = select(tasksTable).join([
      // Using leftOuterJoin:
      // This ensures all tasks matching the routineId are included,
      // even if they don't have a matching entry for the specific normalizedDate.
      leftOuterJoin(
        taskEntriesTable,
        Expression.and([
          taskEntriesTable.taskId.equalsExp(tasksTable.id),
          taskEntriesTable.entryDate.equals(date.dateOnly),
        ]),
      ),
    ]);

    // Filter tasks by the routineId
    query.where(tasksTable.routineId.equals(routine.id.value));

    // Execute the query
    final result = await query.get();

    return result.map((row) {
      final task = row.readTable(tasksTable);
      // taskEntry might be null if there's no entry for the given date (due to leftOuterJoin)
      final taskEntry = row.readTableOrNull(
        taskEntriesTable,
      ); // Use readTableOrNull!

      // If taskEntry is null, create an "empty" or default TaskEntryDto
      final taskEntryDto = taskEntry != null
          ? taskEntry.fromModel(taskEntry.toModel())
          : TaskEntry(
              taskId: task.id,
              id: uuid.generate(),
              completed: false,
              entryDate: date.dateOnly,
            ); // Provide defaults for empty DTO

      return TaskWithEntryDto(task, taskEntryDto);
    }).toList();
  }

  Future<TaskWithEntryDto> insertTask(TaskWithEntryDto task) async {
    return transaction(() async {
      final insertedTask = await into(
        tasksTable,
      ).insertReturning(task.task, mode: InsertMode.insertOrReplace);

      return TaskWithEntryDto(insertedTask, null);
    });
  }

  Future<TaskWithEntryDto> updateTaskWithEntry(
    TaskModel model,
    DateTime entryDate,
    bool value,
  ) async {
    return transaction(() async {
      final task = Task(
        id: model.id,
        title: model.title,
        description: model.description,
        iconIndex: model.iconIndex,
        order: model.order,
        duration: model.duration,
        routineId: model.routineId,
      );
      // Update the task
      final updatedTask = await into(
        tasksTable,
      ).insertReturning(task, mode: InsertMode.insertOrReplace);

      // Upsert the entry (returns the latest entry)
      final entry = await _upsertTaskEntry(task.id, entryDate, value);

      // Return the DTO
      return TaskWithEntryDto(updatedTask, entry);
    });
  }

  Future<TaskEntry> _upsertTaskEntry(
    String taskId,
    DateTime date,
    bool completed,
  ) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    final existingEntry =
        await (select(taskEntriesTable)
              ..where((tEntry) => tEntry.taskId.equals(taskId))
              ..where((tEntry) => tEntry.entryDate.equals(normalizedDate)))
            .getSingleOrNull();

    if (existingEntry != null) {
      final updatedId =
          await (update(taskEntriesTable)
                ..where((tEntry) => tEntry.id.equals(existingEntry.id)))
              .writeReturning(TaskEntryCompanion(completed: Value(completed)));

      return updatedId.single;
    } else {
      return await into(taskEntriesTable).insertReturning(
        TaskEntryCompanion.insert(
          id: uuid.generate(),
          taskId: taskId,
          entryDate: normalizedDate,
          completed: Value(completed),
        ),
      );
    }
  }

  Future<List<Task>> reorderTasks(List<TaskCompanion> orderedTasks) async {
    return transaction(() async {
      final results = <Task>[];

      for (final taskCompanion in orderedTasks) {
        final updated = await into(
          tasksTable,
        ).insertReturning(taskCompanion, mode: InsertMode.insertOrReplace);
        results.add(updated);
      }

      return results;
    });
  }

  Future<Task> updateOnlyTask(TaskModel model) async {
    final companion = TaskCompanion(
      id: Value(model.id),
      title: Value(model.title),
      description: Value(model.description),
      iconIndex: Value(model.iconIndex),
      order: Value(model.order),
      duration: Value(model.duration),
      routineId: Value(model.routineId),
    );

    return await into(
      tasksTable,
    ).insertReturning(companion, mode: InsertMode.insertOrReplace);
  }

  Future<TaskEntry> updateTaskEntry(TaskEntry entry) async {
    final companion = TaskEntryCompanion(
      id: Value(entry.id),
      taskId: Value(entry.taskId),
      entryDate: Value(entry.entryDate),
      completed: Value(entry.completed),
    );

    await (update(
      taskEntriesTable,
    )..where((tbl) => tbl.id.equals(entry.id))).write(companion);

    return (select(
      taskEntriesTable,
    )..where((tbl) => tbl.id.equals(entry.id))).getSingle();
  }

  static final UuidV4 uuid = UuidV4();
}
