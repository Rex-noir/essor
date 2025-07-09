extension DateExtensions on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  DateTime getNextWeekDay(int weekDay) {
    final int daysUntil = (weekDay - weekday) % 7;
    return add(Duration(days: daysUntil < 0 ? daysUntil + 7 : daysUntil));
  }
}
