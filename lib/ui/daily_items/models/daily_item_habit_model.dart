import 'package:mobile/domain/enums/item_type.dart';
import 'package:mobile/domain/models/habit_entry_model.dart';
import 'package:mobile/domain/models/habit_model.dart';
import 'package:mobile/domain/models/habit_progress.dart';
import 'package:mobile/ui/daily_items/models/daily_item_model.dart';

class DailyItemHabitModel extends DailyItemModel {
  final HabitModel habit;
  final HabitEntryModel? entry;

  DailyItemHabitModel({required this.habit, required this.entry});

  HabitProgress get progress {
    if (habit.habitType == ItemType.binary) {
      final isCompleted = entry?.value == 1;
      return HabitProgress(
        value: isCompleted ? 1.0 : 0.0,
        text: isCompleted ? 'Completed' : 'Not completed',
        completed: isCompleted,
      );
    } else {
      final currentValue = entry?.value ?? 0;
      final targetValue = habit.targetValue ?? 1;
      final progress = (currentValue / targetValue).clamp(0.0, 1.0);
      final unit = habit.targetUnit ?? 'units';

      return HabitProgress(
        value: progress,
        text: '$currentValue / $targetValue $unit',
        completed: currentValue >= targetValue,
      );
    }
  }
}
