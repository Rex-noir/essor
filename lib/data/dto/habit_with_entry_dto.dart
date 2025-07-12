import 'package:mobile/database/database.dart';
import 'package:mobile/database/tables/habit_entries_table.dart';
import 'package:mobile/database/tables/habits_table.dart';
import 'package:mobile/domain/models/habit_with_entry_model.dart';

class HabitWithEntryDto {
  final Habit habit;
  final HabitEntry? entry;

  HabitWithEntryDto({required this.habit, required this.entry});

  HabitWithEntryModel toModel() =>
      HabitWithEntryModel(habit: habit.toModel(), entry: entry?.toModel());

  factory HabitWithEntryDto.fromModel(HabitWithEntryModel model) {
    final habit = model.habit;
    final entry = model.entry;

    return HabitWithEntryDto(
      habit: Habit(
        id: habit.id,
        title: habit.title,
        iconIndex: habit.iconIndex,
        description: habit.description,
        frequency: habit.frequency,
        startDate: habit.startDate,
        weeklyDays: habit.weeklyDays,
        monthlyDates: habit.monthlyDates,
        interval: habit.interval,
        isActive: habit.isActive,
        startTime: habit.startTime,
        habitType: habit.habitType,
        targetOperator: habit.targetOperator,
        targetUnit: habit.targetUnit,
        targetValue: habit.targetValue,
        createdAt: habit.createdAt,
        updatedAt: habit.updatedAt,
        deletedAt: habit.deletedAt,
        lastScheduledAt: habit.lastScheduledAt,
      ),
      entry: entry != null
          ? HabitEntry(
              id: entry.id,
              habitId: entry.habitId,
              entryDate: entry.entryDate,
              value: entry.value,
            )
          : null,
    );
  }
}
