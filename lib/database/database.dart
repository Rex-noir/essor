import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:mobile/database/converters/duration_converter.dart';
import 'package:mobile/database/converters/habit_target_operator_converter.dart';
import 'package:mobile/database/converters/int_list_converter.dart';
import 'package:mobile/database/converters/item_frequency_converter.dart';
import 'package:mobile/database/converters/item_type_converter.dart';
import 'package:mobile/database/converters/time_of_day_converter.dart';
import 'package:mobile/database/tables/habit_entries_table.dart';
import 'package:mobile/database/tables/habits_table.dart';
import 'package:mobile/database/tables/notification_entries_table.dart';
import 'package:mobile/database/tables/routines_table.dart';
import 'package:mobile/database/tables/task_entries_table.dart';
import 'package:mobile/database/tables/tasks_table.dart';
import 'package:mobile/domain/enums/habit_target_operator_enum.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/domain/enums/item_type.dart';
import 'package:mobile/utils/app_logger.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    RoutinesTable,
    HabitsTable,
    TasksTable,
    TaskEntriesTable,
    HabitEntriesTable,
    NotificationEntriesTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  static QueryExecutor _openConnection({bool reset = false}) {
    final logger = AppLogger.tag("AppDatabase");
    return LazyDatabase(() async {
      final dir = await getApplicationSupportDirectory();
      final path = '${dir.path}/app_database.sqlite';

      final file = File(path);
      if (reset && await file.exists()) {
        await file.delete();
        logger.debug('Database file deleted for reset.');
      }

      return NativeDatabase(file);
    });
  }

  @override
  int get schemaVersion => 1;
}
