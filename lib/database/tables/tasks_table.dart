import 'package:drift/drift.dart';
import 'package:mobile/database/converters/duration_converter.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/database/tables/routines_table.dart';
import 'package:mobile/domain/models/task_model.dart';

@DataClassName("Task", companion: "TaskCompanion")
class TasksTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get iconIndex => integer().withDefault(const Constant(0))();

  IntColumn get order => integer()();

  // Storing duration as total seconds
  IntColumn get duration => integer().map(const DurationConverter())();
  TextColumn get routineId =>
      text().references(RoutinesTable, #id).nullable()(); // Added .nullable()

  @override
  Set<Column> get primaryKey => {id};
}

extension TaskExtensions on Task {
  TaskModel toModel() => TaskModel(
    id: id,
    title: title,
    description: description,
    iconIndex: iconIndex,
    order: order,
    duration: duration,
    routineId: routineId,
  );

  Task fromModel(TaskModel model) => Task(
    id: model.id,
    title: model.title,
    description: model.description,
    iconIndex: model.iconIndex,
    order: model.order,
    duration: model.duration,
    routineId: model.routineId,
  );
}
