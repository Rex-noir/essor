import 'package:drift/drift.dart';
import 'package:mobile/database/database.dart';

import '../tables/notification_entries_table.dart';

part 'notification_entry_dao.g.dart';

@DriftAccessor(tables: [NotificationEntriesTable])
class NotificationEntryDao extends DatabaseAccessor<AppDatabase>
    with _$NotificationEntryDaoMixin {
  NotificationEntryDao(super.attachedDatabase);

  Future<void> insertEntry(NotificationEntryCompanion entry) async {
    await into(notificationEntriesTable).insertReturning(entry);
  }

  Future<void> updateEntry(NotificationEntryCompanion companion) async {
    await into(notificationEntriesTable).insertOnConflictUpdate(companion);
  }

  Future<List<NotificationEntry>> getAllEntriesByModelId(String modelId) {
    return (select(
      notificationEntriesTable,
    )..where((tbl) => tbl.modelId.equals(modelId))).get();
  }

  Future<List<NotificationEntry>> getAllEntries() {
    return select(notificationEntriesTable).get();
  }

  Future<void> deleteById(int id) async {
    await (delete(
      notificationEntriesTable,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> deleteByModelId(String modelId) async {
    await (delete(
      notificationEntriesTable,
    )..where((tbl) => tbl.modelId.equals(modelId))).go();
  }

  Future<void> deleteByModelIds(List<String> modelIds) async {
    if (modelIds.isEmpty) return;
    await (delete(
      notificationEntriesTable,
    )..where((tbl) => tbl.modelId.isIn(modelIds))).go();
  }

  Future<void> deleteByNotificationId(int id) async {
    await (delete(
      notificationEntriesTable,
    )..where((tbl) => tbl.notificationId.equals(id))).go();
  }
}
