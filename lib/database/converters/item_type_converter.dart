import 'package:drift/drift.dart';
import 'package:mobile/domain/enums/item_type.dart';

class ItemTypeConverter extends TypeConverter<ItemType, String> {
  const ItemTypeConverter();
  @override
  ItemType fromSql(String fromDb) {
    return ItemType.values.firstWhere((type) => type.name == fromDb);
  }

  @override
  String toSql(ItemType value) {
    return value.name;
  }
}
