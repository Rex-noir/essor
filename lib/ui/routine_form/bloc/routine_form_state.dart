part of 'routine_form_bloc.dart';

enum RoutineFormMode { create, edit }

class RoutineFormState extends Equatable {
  final ItemFrequency selectedFrequency;
  final int interval;
  final List<int> weeklyDays;
  final DateTime startDate;
  final List<int> monthlyDates;
  final TimeOfDay startTime;
  final String title;
  final int iconIndex;
  final RoutineFormMode? mode;
  final String? id;

  const RoutineFormState({
    required this.selectedFrequency,
    required this.interval,
    required this.weeklyDays,
    required this.iconIndex,
    required this.title,
    required this.startTime,
    required this.startDate,
    required this.monthlyDates,
    this.id,
    this.mode = RoutineFormMode.create,
  });

  factory RoutineFormState.empty() => RoutineFormState(
    title: '',
    iconIndex: 1,
    selectedFrequency: ItemFrequency.daily,
    startTime: TimeOfDay(hour: 8, minute: 00),
    interval: 2,
    weeklyDays: const [],
    monthlyDates: const [],
    startDate: DateTime.now(),
    mode: RoutineFormMode.create,
  );

  @override
  List<Object?> get props => [
    title,
    iconIndex,
    selectedFrequency,
    interval,
    weeklyDays,
    startDate,
    monthlyDates,
    startTime,
    mode,
    id,
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
    RoutineFormMode? mode,
    String? id,
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
      mode: mode ?? this.mode,
      id: id ?? this.id,
    );
  }
}
