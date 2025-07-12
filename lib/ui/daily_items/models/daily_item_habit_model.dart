import 'package:mobile/domain/enums/habit_target_operator_enum.dart';
import 'package:mobile/domain/enums/item_type.dart';
import 'package:mobile/domain/models/habit_entry_model.dart';
import 'package:mobile/domain/models/habit_model.dart';
import 'package:mobile/ui/daily_items/models/daily_item_model.dart';

class DailyItemHabitModel extends DailyItemModel {
  final HabitModel habit;
  final HabitEntryModel? entry;

  DailyItemHabitModel({required this.habit, required this.entry});

  bool get isCompleted {
    if (entry == null) return false;

    final value = entry!.value;
    final target = habit.targetValue ?? 1;

    if (habit.habitType == ItemType.binary) {
      return value == 1;
    }
    switch (habit.targetOperator) {
      case TargetOperator.greaterThanOrEqual:
        return value >= target;
      case TargetOperator.equalTo:
        return value == target;
      case TargetOperator.lessThanOrEqual:
        return value <= target;
    }
  }
}
