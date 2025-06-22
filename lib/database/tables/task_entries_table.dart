import 'package:drift/drift.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/database/tables/tasks_table.dart';
import 'package:mobile/domain/models/task_entry_model.dart';

@DataClassName("TaskEntry", companion: "TaskEntryCompanion")
class TaskEntriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(TasksTable, #id)();
  DateTimeColumn get entryDate => dateTime()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

extension TaskEntryExtension on TaskEntry {
  TaskEntryModel toModel() => TaskEntryModel(
    id: id,
    taskId: taskId,
    entryDate: entryDate,
    completed: completed,
  );

  TaskEntry fromModel(TaskEntryModel model) => TaskEntry(
    id: model.id,
    taskId: model.taskId,
    entryDate: model.entryDate,
    completed: model.completed,
  );
}
