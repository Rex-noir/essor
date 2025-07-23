import 'package:mobile/domain/models/notification_entry_model.dart';

abstract class NotificationEntryRepository {
  Future<void> insertEntry(NotificationEntryModel entry);

  Future<void> deleteEntry(NotificationEntryModel entry);

  Future<List<NotificationEntryModel>> getAllEntriesByModelId(String id);
}
