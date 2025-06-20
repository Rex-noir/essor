import 'package:mobile/domain/enums/item_frequency.dart';

String getFrequencyIntervalLabel(ItemFrequency frequency, int interval) {
  if (frequency == ItemFrequency.daily && interval == 1) {
    return 'Daily';
  }
  if (frequency == ItemFrequency.weekly && interval == 1) {
    return 'Weekly';
  }

  if (frequency == ItemFrequency.daily && interval > 1) {
    return 'Every $interval days';
  }
  if (frequency == ItemFrequency.weekly && interval > 1) {
    return 'Every $interval weeks';
  }
  if (frequency == ItemFrequency.monthly && interval > 1) {
    return 'Every $interval months';
  }
  return '';
}
