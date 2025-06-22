part of 'new_routine_bloc.dart';

class NewRoutineState extends Equatable {
  final ItemFrequency selectedFrequency;
  final int interval;
  final List<int> weeklyDays;
  final DateTime startDate;
  final List<int> monthlyDates;
  final TimeOfDay startTime;

  const NewRoutineState({
    required this.selectedFrequency,
    required this.interval,
    required this.weeklyDays,
    required this.startTime,
    required this.startDate,
    required this.monthlyDates,
  });

  factory NewRoutineState.initial() => NewRoutineState(
    selectedFrequency: ItemFrequency.daily,
    startTime: TimeOfDay(hour: 8, minute: 00),
    interval: 2,
    weeklyDays: const [],
    monthlyDates: const [],
    startDate: DateTime.now(),
  );

  @override
  List<Object> get props => [
    selectedFrequency,
    interval,
    weeklyDays,
    startDate,
    monthlyDates,
    startTime,
  ];

  NewRoutineState copyWith({
    ItemFrequency? selectedFrequency,
    int? interval,
    List<int>? weeklyDays,
    TimeOfDay? startTime,
    DateTime? startDate,
    List<int>? monthlyDates,
  }) {
    return NewRoutineState(
      selectedFrequency: selectedFrequency ?? this.selectedFrequency,
      interval: interval ?? this.interval,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      startTime: startTime ?? this.startTime,
      startDate: startDate ?? this.startDate,
      monthlyDates: monthlyDates ?? this.monthlyDates,
    );
  }
}
