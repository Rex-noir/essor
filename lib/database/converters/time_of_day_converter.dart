import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

class TimeOfDayConverter extends TypeConverter<TimeOfDay, String> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromSql(String fromDb) {
    final parts = fromDb.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  String toSql(TimeOfDay value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
