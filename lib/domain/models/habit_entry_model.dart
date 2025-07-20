class HabitEntryModel {
  final String habitId;
  final DateTime entryDate;
  final double value;
  final String id;

  HabitEntryModel({
    required this.habitId,
    required this.entryDate,
    required this.value,
    required this.id,
  });

  HabitEntryModel copyWith({
    String? habitId,
    DateTime? entryDate,
    double? value,
    String? id,
  }) {
    return HabitEntryModel(
      habitId: habitId ?? this.habitId,
      entryDate: entryDate ?? this.entryDate,
      value: value ?? this.value,
      id: id ?? this.id,
    );
  }
}
