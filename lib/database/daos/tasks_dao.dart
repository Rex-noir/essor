import 'package:drift/drift.dart';
import 'package:mobile/core/extensions/date_extensions.dart';
import 'package:mobile/data/dto/routine_dto.dart';
import 'package:mobile/data/dto/task_with_entry_dto.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/database/tables/task_entries_table.dart';
import 'package:mobile/database/tables/tasks_table.dart';
import 'package:uuid/v4.dart';

part "tasks_dao.g.dart";

@DriftAccessor(tables: [TasksTable, TaskEntriesTable])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.attachedDatabase);

  Future<List<TaskWithEntryDto>> fetchTasksWithEntry(
    RoutineDto routine,
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
    query.where(tasksTable.routineId.equals(routine.id));

    // Execute the query
    final result = await query.get();

    return result.map((row) {
      final task = row.readTable(tasksTable);
      // taskEntry might be null if there's no entry for the given date (due to leftOuterJoin)
      final taskEntry = row.readTableOrNull(
        taskEntriesTable,
      ); // Use readTableOrNull!

      final taskDto = task.fromModel(task.toModel());
      // If taskEntry is null, create an "empty" or default TaskEntryDto
      final taskEntryDto = taskEntry != null
          ? taskEntry.fromModel(taskEntry.toModel())
          : TaskEntry(
              taskId: task.id,
              id: uuid.generate(),
              completed: false,
              entryDate: date.dateOnly,
            ); // Provide defaults for empty DTO

      return TaskWithEntryDto(taskDto, taskEntryDto);
    }).toList();
  }

  Future<TaskWithEntryDto> insertTask(TaskWithEntryDto task) async {
    return transaction(() async {
      final insertedTask = await into(
        tasksTable,
      ).insertReturning(task.task, mode: InsertMode.insertOrReplace);

      final insertedEntry = await into(
        taskEntriesTable,
      ).insertReturning(task.entry, mode: InsertMode.insertOrReplace);

      return TaskWithEntryDto(insertedTask, insertedEntry);
    });
  }

  Future<TaskWithEntryDto> updateTaskWithEntry(TaskWithEntryDto dto) async {
    return transaction(() async {
      await batch((batch) {
        batch.replace(tasksTable, dto.task);
      });

      await _upsertTaskEntry(
        dto.entry.taskId,
        dto.entry.entryDate,
        dto.entry.completed,
      );

      return dto;
    });
  }

  Future<void> _upsertTaskEntry(
    String taskId,
    DateTime date,
    bool completed,
  ) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Find if an entry already exists for this task and date
    final existingEntry =
        await (select(taskEntriesTable)
              ..where((tEntry) => tEntry.taskId.equals(taskId))
              ..where((tEntry) => tEntry.entryDate.equals(normalizedDate)))
            .getSingleOrNull();

    if (existingEntry != null) {
      // Update existing entry
      await (update(taskEntriesTable)
            ..where((tEntry) => tEntry.id.equals(existingEntry.id)))
          .write(TaskEntryCompanion(completed: Value(completed)));
    } else {
      // Insert new entry
      await into(taskEntriesTable).insert(
        TaskEntryCompanion.insert(
          id: uuid.generate(), // Generate a new UUID for a new entry
          taskId: taskId,
          entryDate: normalizedDate,
          completed: Value(completed),
        ),
      );
    }
  }

  static final UuidV4 uuid = UuidV4();
}
