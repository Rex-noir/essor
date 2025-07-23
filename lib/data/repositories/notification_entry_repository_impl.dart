import 'package:mobile/database/daos/notification_entry_dao.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/database/tables/notification_entries_table.dart';
import 'package:mobile/domain/models/notification_entry_model.dart';
import 'package:mobile/domain/repositories/notification_entry_repository.dart';

class NotificationEntryRepositoryImpl implements NotificationEntryRepository {
  final NotificationEntryDao _dao;

  const NotificationEntryRepositoryImpl(this._dao);

  @override
  Future<void> deleteEntry(NotificationEntryModel entry) async {
    await _dao.deleteById(entry.id!);
  }

  @override
  Future<List<NotificationEntryModel>> getAllEntriesByModelId(String id) async {
    return (await _dao.getAllEntriesByModelId(
      id,
    )).map((entry) => entry.toModel()).toList();
  }

  @override
  Future<void> insertEntry(NotificationEntryModel entry) async {
    await _dao.insertEntry(
      NotificationEntryCompanion.insert(
        modelId: entry.modelId,
        notificationId: entry.notificationId,
        date: entry.date,
      ),
    );
  }
}
