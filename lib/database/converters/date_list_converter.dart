import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mobile/data/dto/date_list_dto.dart';

class DateListConverter extends TypeConverter<List<DateTime>, String> {
  const DateListConverter();

  @override
  List<DateTime> fromSql(String fromDb) {
    final wrapper = DateListDto.fromJson(json.decode(fromDb));
    return wrapper.dates;
  }

  @override
  String toSql(List<DateTime> value) {
    final wrapper = DateListDto(dates: value);
    return json.encode(wrapper.toJson());
  }
}
