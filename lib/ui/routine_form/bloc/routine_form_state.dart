part of 'routine_form_bloc.dart';


class RoutineFormState extends Equatable {
  final ItemFrequency selectedFrequency;
  final int interval;
  final List<int> weeklyDays;
  final DateTime startDate;
  final List<int> monthlyDates;
  final TimeOfDay startTime;
  final String title;
  final int iconIndex;

  const RoutineFormState({
    required this.selectedFrequency,
    required this.interval,
    required this.weeklyDays,
    required this.iconIndex,
    required this.title,
    required this.startTime,
    required this.startDate,
    required this.monthlyDates,
  });

  factory RoutineFormState.initial() => RoutineFormState(
    title: '',
    iconIndex: 1,
    selectedFrequency: ItemFrequency.daily,
    startTime: TimeOfDay(hour: 8, minute: 00),
    interval: 2,
    weeklyDays: const [],
    monthlyDates: const [],
    startDate: DateTime.now(),
  );

  @override
  List<Object> get props => [
    title,
    iconIndex,
    selectedFrequency,
    interval,
    weeklyDays,
    startDate,
    monthlyDates,
    startTime,
  ];
  RoutineFormState copyWith({
    String? title,
    int? iconIndex,
    ItemFrequency? selectedFrequency,
    int? interval,
    List<int>? weeklyDays,
    TimeOfDay? startTime,
    DateTime? startDate,
    List<int>? monthlyDates,
  }) {
    return RoutineFormState(
      title: title ?? this.title,
      iconIndex: iconIndex ?? this.iconIndex,
      selectedFrequency: selectedFrequency ?? this.selectedFrequency,
      interval: interval ?? this.interval,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      startTime: startTime ?? this.startTime,
      startDate: startDate ?? this.startDate,
      monthlyDates: monthlyDates ?? this.monthlyDates,
    );
  }
}
