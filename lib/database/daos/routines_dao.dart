import 'package:drift/drift.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/database/tables/routines_table.dart';

part 'routines_dao.g.dart';

@DriftAccessor(tables: [RoutinesTable])
class RoutinesDao extends DatabaseAccessor<AppDatabase>
    with _$RoutinesDaoMixin {
  RoutinesDao(super.attachedDatabase);

  Future<List<Routine>> fetchAllActiveBeforeDate(DateTime date) {
    return (select(routinesTable)..where(
          (tbl) =>
              tbl.deletedAt.isNull() &
              tbl.startDate.isSmallerOrEqualValue(date),
        ))
        .get();
  }
}
