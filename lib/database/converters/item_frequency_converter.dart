import 'package:drift/drift.dart';
import 'package:mobile/domain/enums/item_frequency.dart';

class ItemFrequencyConverter extends TypeConverter<ItemFrequency, int> {
  const ItemFrequencyConverter();

  @override
  ItemFrequency fromSql(int fromDb) => ItemFrequency.values[fromDb];

  @override
  int toSql(ItemFrequency value) => value.index;
}
