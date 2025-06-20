import 'package:drift/drift.dart';
import 'package:mobile/database/converters/date_list_converter.dart';
import 'package:mobile/database/converters/int_list_converter.dart';
import 'package:mobile/database/converters/item_frequency_converter.dart';
import 'package:mobile/database/converters/item_type_converter.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/domain/models/habit_model.dart';

@DataClassName("Habit")
class HabitsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get iconIndex => integer()();

  IntColumn get frequency => integer().map(const ItemFrequencyConverter())();
  DateTimeColumn get startDate => dateTime()();

  TextColumn get weeklyDays =>
      text().map(const IntListConverter()).withDefault(const Constant('[]'))();
  TextColumn get monthlyDates =>
      text().map(const DateListConverter()).withDefault(const Constant('[]'))();

  IntColumn get interval => integer().withDefault(const Constant(1))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  TextColumn get habitType => text().map(const ItemTypeConverter())();

  TextColumn get targetUnit => text().nullable()();
  IntColumn get targetValue => integer().nullable()();
  TextColumn get targetOperator => text().withDefault(const Constant('='))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

extension HabitExtension on Habit {
  HabitModel toModel() {
    return HabitModel(
      id: id,
      title: title,
      description: description,
      iconIndex: iconIndex,
      frequency: frequency,
      startDate: startDate,
      weeklyDays: weeklyDays,
      monthlyDates: monthlyDates,
      interval: interval,
      isActive: isActive,
      habitType: habitType,
      targetUnit: targetUnit,
      targetValue: targetValue,
      targetOperator: targetOperator,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
