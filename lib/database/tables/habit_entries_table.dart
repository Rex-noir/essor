import 'package:drift/drift.dart';
import 'package:mobile/database/tables/habits_table.dart';
import 'package:mobile/domain/models/habit_entry_model.dart';

import '../database.dart';

@DataClassName("HabitEntry", companion: "HabitEntryCompanion")
class HabitEntriesTable extends Table {
  TextColumn get id => text()();

  TextColumn get habitId => text().references(HabitsTable, #id)();

  DateTimeColumn get entryDate => dateTime()();

  RealColumn get value => real()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

extension HabitEntryExtension on HabitEntry {
  HabitEntryModel toModel() => HabitEntryModel(
    habitId: habitId,
    entryDate: entryDate,
    value: value,
    id: id,
  );

  HabitEntry fromModel() =>
      HabitEntry(id: id, habitId: habitId, entryDate: entryDate, value: value);
}
