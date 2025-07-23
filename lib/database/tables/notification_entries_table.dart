import 'package:drift/drift.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/domain/models/notification_entry_model.dart';

@DataClassName("NotificationEntry", companion: "NotificationEntryCompanion")
class NotificationEntriesTable extends Table {
  TextColumn get modelId => text()();

  IntColumn get id => integer().autoIncrement()();

  IntColumn get notificationId => integer()();

  DateTimeColumn get date => dateTime()();
}

extension NotificationEntryExtension on NotificationEntry {
  NotificationEntryModel toModel() {
    return NotificationEntryModel(
      modelId: modelId,
      notificationId: notificationId,
      date: date,
      id: id,
    );
  }
}
