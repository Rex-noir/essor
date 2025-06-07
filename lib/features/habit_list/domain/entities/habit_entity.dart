// ignore_for_file: public_member_api_docs, sort_constructors_first
enum HabitFrequency { daily, weekly, monthly }

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class HabitEntity {
  final String id;
  final String title;
  final String? description;
  //enum
  final HabitFrequency frequency;
  final DateTime startDate;
  final List<DayOfWeek> weeklyDays;
  final List<int> monthlyDates;
  final int repeatEvery;
  final bool isActive;

  const HabitEntity({
    required this.id,
    required this.title,
    this.description,
    required this.frequency,
    required this.startDate,
    this.weeklyDays = const [],
    this.monthlyDates = const [],
    this.repeatEvery = 1,
    this.isActive = true,
  });

  HabitEntity copyWith({
    String? id,
    String? title,
    String? description,
    HabitFrequency? frequency,
    DateTime? startDate,
    List<DayOfWeek>? weeklyDays,
    List<int>? monthlyDates,
    int? repeatEvery,
    bool? isActive,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      monthlyDates: monthlyDates ?? this.monthlyDates,
      repeatEvery: repeatEvery ?? this.repeatEvery,
      isActive: isActive ?? this.isActive,
    );
  }
}
