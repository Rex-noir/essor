import 'package:drift/drift.dart';
import 'package:mobile/database/converters/int_list_converter.dart';
import 'package:mobile/database/converters/item_frequency_converter.dart';
import 'package:mobile/database/converters/time_of_day_converter.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/domain/models/routine_model.dart';

@DataClassName("Routine")
class RoutinesTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get userId => text().withLength(min: 36, max: 36)();
  TextColumn get title => text().withLength(max: 255)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get startDate => dateTime()();
  TextColumn get startTime => text().map(const TimeOfDayConverter())();
  TextColumn get weeklyDays =>
      text().map(const IntListConverter()).withDefault(const Constant('[]'))();
  IntColumn get frequency => integer().map(const ItemFrequencyConverter())();
  TextColumn get monthlyDates =>
      text().map(const IntListConverter()).withDefault(const Constant('[]'))();

  IntColumn get iconIndex => integer().withDefault(const Constant(0))();

  IntColumn get interval => integer().withDefault(const Constant(1))();
  BoolColumn get isShared => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

extension RoutineDataExtension on Routine {
  RoutineModel toModel() {
    return RoutineModel(
      id: id,
      title: title,
      description: description,
      iconIndex: iconIndex,
      startDate: startDate,
      startTime: startTime,
      weeklyDays: weeklyDays,
      frequency: frequency,
      monthlyDates: monthlyDates,
      interval: interval,
      isShared: isShared,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      syncVersion: syncVersion,
    );
  }
}
