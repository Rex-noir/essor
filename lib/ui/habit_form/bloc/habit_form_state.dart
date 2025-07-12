part of 'habit_form_bloc.dart';

enum HabitFormMode { edit, create }

final class HabitFormState extends Equatable {
  final String id;
  final String title;
  final String? description;
  final int iconIndex;
  final ItemFrequency frequency;
  final DateTime startDate;
  final List<int> weeklyDays;
  final List<int> monthlyDates;
  final int interval;
  final bool isActive;
  final ItemType habitType;
  final String? targetUnit;
  final int? targetValue;
  final TargetOperator targetOperator;
  final HabitFormMode mode;
  final TimeOfDay startTime;
  final DateTime? lastScheduledAt;

  const HabitFormState({
    required this.id,
    required this.title,
    required this.description,
    required this.iconIndex,
    required this.lastScheduledAt,
    required this.frequency,
    required this.startDate,
    required this.weeklyDays,
    required this.monthlyDates,
    required this.interval,
    required this.isActive,
    required this.habitType,
    required this.targetUnit,
    required this.targetValue,
    required this.targetOperator,
    required this.startTime,
    this.mode = HabitFormMode.create,
  });

  factory HabitFormState.empty() => HabitFormState(
    id: const UuidV4().generate(),
    title: '',
    description: '',
    iconIndex: 1,
    lastScheduledAt: null,
    frequency: ItemFrequency.daily,
    startDate: DateTime.now(),
    weeklyDays: const [],
    monthlyDates: const [],
    interval: 2,
    isActive: true,
    habitType: ItemType.binary,
    targetUnit: '',
    targetValue: null,
    startTime: TimeOfDay(hour: 8, minute: 00),
    targetOperator: TargetOperator.equalTo,
  );

  HabitFormState copyWith({
    String? id,
    String? title,
    String? description,
    int? iconIndex,
    ItemFrequency? frequency,
    DateTime? startDate,
    List<int>? weeklyDays,
    List<int>? monthlyDates,
    int? interval,
    bool? isActive,
    ItemType? habitType,
    String? targetUnit,
    int? targetValue,
    TargetOperator? targetOperator,
    TimeOfDay? startTime,
    HabitFormMode? mode,
    DateTime? lastScheduledAt,
  }) {
    return HabitFormState(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconIndex: iconIndex ?? this.iconIndex,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      monthlyDates: monthlyDates ?? this.monthlyDates,
      lastScheduledAt: lastScheduledAt ?? this.lastScheduledAt,
      interval: interval ?? this.interval,
      isActive: isActive ?? this.isActive,
      habitType: habitType ?? this.habitType,
      targetUnit: targetUnit ?? this.targetUnit,
      targetValue: targetValue ?? this.targetValue,
      targetOperator: targetOperator ?? this.targetOperator,
      mode: mode ?? this.mode,
      startTime: startTime ?? this.startTime,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    iconIndex,
    frequency,
    startDate,
    weeklyDays,
    monthlyDates,
    interval,
    isActive,
    habitType,
    targetUnit,
    targetValue,
    targetOperator,
    mode,
    startTime,
  ];
}
