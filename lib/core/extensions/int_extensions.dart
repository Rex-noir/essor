import 'package:intl/intl.dart';

extension WeekdayNameExtension on int {
  String get weekdayName {
    if (this < 1 || this > 7) return 'Invalid';
    final date = DateTime.utc(2024, 1, this);
    return DateFormat.EEEE().format(date);
  }

  String get shortWeekdayName {
    if (this < 1 || this > 7) return 'Invalid';
    final date = DateTime.utc(2024, 1, this);
    return DateFormat.E().format(date); // e.g., "Mon"
  }
}
