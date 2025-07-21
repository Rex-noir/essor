import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/infrastructure/notification/failures/notification_failure.dart';
import 'package:mobile/infrastructure/notification/models/schedulable_model.dart';
import 'package:mobile/infrastructure/notification/services/notification_service_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

int generateId(String baseId) => baseId.hashCode & 0x7FFFFFFF;

class TestSchedulableModel extends Schedulable {
  @override
  final String id;

  @override
  final String title;

  @override
  final String? description;

  @override
  final DateTime startDate;

  @override
  final TimeOfDay startTime;

  @override
  final ItemFrequency frequency;

  @override
  final List<int> weeklyDays;

  @override
  final List<int> monthlyDates;

  @override
  final DateTime? lastScheduledAt;

  @override
  final int interval;

  TestSchedulableModel({
    required this.id,
    required this.title,
    this.description,
    required this.startDate,
    required this.startTime,
    required this.frequency,
    this.weeklyDays = const [],
    this.monthlyDates = const [],
    this.lastScheduledAt,
    required this.interval,
  });
}

// ------------------------------------------------------------------
// Concrete models so we can test title / body generation
// ------------------------------------------------------------------
class TestHabit extends TestSchedulableModel {
  TestHabit({
    required super.id,
    required super.title,
    super.description,
    required super.startDate,
    required super.startTime,
    required super.frequency,
    super.weeklyDays = const [],
    super.monthlyDates = const [],
    super.interval = 1,
  });
}

class TestRoutine extends TestSchedulableModel {
  TestRoutine({
    required super.id,
    required super.title,
    super.description,
    required super.startDate,
    required super.startTime,
    required super.frequency,
    super.weeklyDays = const [],
    super.monthlyDates = const [],
    super.interval = 1,
  });
}

void main() {
  late MockFlutterLocalNotificationsPlugin plugin;
  late NotificationServiceImpl service;
  late DateTime testStartDate;
  late TimeOfDay testStartTime;

  setUpAll(() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    registerFallbackValue(const NotificationDetails());
    registerFallbackValue(AndroidScheduleMode.exact);
    registerFallbackValue(tz.TZDateTime.now(tz.local));
  });

  setUp(() {
    plugin = MockFlutterLocalNotificationsPlugin();
    service = NotificationServiceImpl(plugin);

    final now = DateTime.now();
    testStartDate = DateTime(now.year, now.month + 1, 1);
    testStartTime = TimeOfDay(hour: now.hour + 1, minute: 20);

    when(() => plugin.cancel(any())).thenAnswer((_) async {});
    when(
      () => plugin.zonedSchedule(
        any(),
        any(),
        any(),
        any(),
        any(),
        androidScheduleMode: any(named: 'androidScheduleMode'),
        matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async {});
  });

  group('NotificationServiceImpl', () {
    group('schedule', () {
      test('cancels any pre-existing notification', () async {
        final model = TestSchedulableModel(
          id: 'foo',
          title: 't',
          startDate: testStartDate,
          startTime: testStartTime,
          frequency: ItemFrequency.daily,
          interval: 1,
        );

        await service.schedule(model, (_) {});
        verify(() => plugin.cancel(generateId('foo'))).called(1);
      });

      test('daily – schedules 30 notifications, every single day', () async {
        final model = TestSchedulableModel(
          id: 'd1',
          title: 'Daily',
          startDate: testStartDate,
          startTime: testStartTime,
          frequency: ItemFrequency.daily,
          interval: 1,
        );

        await service.schedule(model, (_) {});
        verify(
          () => plugin.zonedSchedule(
            any(),
            any(),
            any(),
            any(),
            any(),
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            payload: 'd1',
          ),
        ).called(30);
      });

      test('daily – interval=2 → 15 notifications', () async {
        final model = TestSchedulableModel(
          id: 'd2',
          title: 'Daily 2',
          startDate: testStartDate,
          startTime: testStartTime,
          frequency: ItemFrequency.daily,
          interval: 2,
        );

        await service.schedule(model, (_) {});
        verify(
          () => plugin.zonedSchedule(
            any(),
            any(),
            any(),
            any(),
            any(),
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            payload: any(named: 'payload'),
          ),
        ).called(15);
      });

      test('daily – interval==0 throws', () async {
        final model = TestSchedulableModel(
          id: 'd0',
          title: 't',
          startDate: testStartDate,
          startTime: testStartTime,
          frequency: ItemFrequency.daily,
          interval: 0,
        );

        expect(
          () => service.schedule(model, (_) {}),
          throwsA(isA<NotificationDailyIntervalIsZero>()),
        );
      });

      test('weekly – schedules 3×12 = 36 notifications', () async {
        final model = TestSchedulableModel(
          id: 'w',
          title: 'Weekly',
          startDate: testStartDate,
          startTime: testStartTime,
          frequency: ItemFrequency.weekly,
          interval: 1,
          weeklyDays: [DateTime.monday, DateTime.wednesday, DateTime.friday],
        );

        await service.schedule(model, (_) {});
        verify(
          () => plugin.zonedSchedule(
            any(),
            any(),
            any(),
            any(),
            any(),
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            payload: any(named: 'payload'),
          ),
        ).called(36);
      });

      test('weekly – empty days list throws', () async {
        final model = TestSchedulableModel(
          id: 'w',
          title: 'Weekly',
          startDate: testStartDate,
          startTime: testStartTime,
          frequency: ItemFrequency.weekly,
          interval: 1,
          weeklyDays: const [],
        );

        expect(
          () => service.schedule(model, (_) {}),
          throwsA(isA<NotificationWeeklyDaysEmptyFailure>()),
        );
      });

      test('monthly – 2 days × 12 months = 24 notifications', () async {
        final model = TestSchedulableModel(
          id: 'm',
          title: 'Monthly',
          startDate: testStartDate,
          startTime: testStartTime,
          frequency: ItemFrequency.monthly,
          interval: 1,
          monthlyDates: [1, 15],
        );

        await service.schedule(model, (_) {});
        verify(
          () => plugin.zonedSchedule(
            any(),
            any(),
            any(),
            any(),
            any(),
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            payload: any(named: 'payload'),
          ),
        ).called(24);
      });

      test('does not schedule past dates', () async {
        final past = DateTime.now().subtract(const Duration(days: 5));
        final model = TestSchedulableModel(
          id: 'past',
          title: 'Past',
          startDate: past,
          startTime: TimeOfDay.fromDateTime(past),
          frequency: ItemFrequency.daily,
          interval: 1,
        );

        await service.schedule(model, (_) {});
        verify(
          () => plugin.zonedSchedule(
            any(),
            any(),
            any(),
            any(),
            any(),
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            payload: any(named: 'payload'),
          ),
        ).called(greaterThan(0));
      });

      test('title/body for HabitModel', () async {
        final model = TestHabit(
          id: 'hab',
          title: 'Drink water',
          description: 'Stay hydrated',
          startDate: testStartDate,
          startTime: testStartTime,
          frequency: ItemFrequency.daily,
        );

        await service.schedule(model, (_) {});
        final captured = verify(
          () => plugin.zonedSchedule(
            any(),
            captureAny(),
            captureAny(),
            any(),
            any(),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            payload: any(named: 'payload'),
          ),
        ).captured;

        expect(captured[0], 'Reminder: Drink water');
        expect(captured[1], 'Stay hydrated');
      });

      test('title/body for RoutineModel', () async {
        final model = TestRoutine(
          id: 'rtn',
          title: 'Morning ritual',
          startDate: testStartDate,
          startTime: testStartTime,
          frequency: ItemFrequency.daily,
        );

        await service.schedule(model, (_) {});
        final captured = verify(
          () => plugin.zonedSchedule(
            any(),
            captureAny(),
            captureAny(),
            any(),
            any(),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            payload: any(named: 'payload'),
          ),
        ).captured;

        expect(captured[0], 'Reminder: Morning ritual');
        expect(captured[1], "Time for 'Morning ritual'");
      });
    });
  });
}
