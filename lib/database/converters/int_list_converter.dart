import 'dart:convert';

import 'package:drift/drift.dart';

class IntListConverter extends TypeConverter<List<int>, String> {
  const IntListConverter();

  @override
  List<int> fromSql(String fromDb) {
    final decoded = json.decode(fromDb);
    if (decoded is List) {
      return decoded.cast<int>();
    }
    return [];
  }

  @override
  String toSql(List<int> value) => json.encode(value);
}
