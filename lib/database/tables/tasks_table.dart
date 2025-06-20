import 'package:drift/drift.dart';
import 'package:mobile/database/converters/duration_converter.dart';
import 'package:mobile/database/tables/routines_table.dart';

@DataClassName("Task")
class TasksTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get iconIndex => integer().withDefault(const Constant(0))();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get importance => integer()();

  // Storing duration as total seconds
  IntColumn get duration => integer().map(const DurationConverter())();
  IntColumn get routineId => integer()
      .references(RoutinesTable, #id)
      .nullable()(); // Added .nullable()

  @override
  Set<Column> get primaryKey => {id};
}
