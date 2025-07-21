import 'package:mobile/domain/failures/failures.dart';

class NotificationFailure extends Failure {
  const NotificationFailure({String? message})
    : super(
        message: message ?? 'Notification error occurred.',
        code: 'notify-err',
      );
}

class NotificationWeeklyDaysEmptyFailure extends NotificationFailure {
  const NotificationWeeklyDaysEmptyFailure()
    : super(message: "Weekly days empty for weekly frequency.");
}

class NotificationDailyIntervalIsZero extends NotificationFailure {
  const NotificationDailyIntervalIsZero()
    : super(
        message:
            "Can't set interval to value of zero if the frequency is daily.",
      );
}

class NotificationMonthlyDaysEmpty extends NotificationFailure {
  const NotificationMonthlyDaysEmpty() : super(message: "Empty monthly dates.");
}
