import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/models/task_with_entry_model.dart';
import 'package:mobile/ui/daily_items/models/daily_item_model.dart';

class DailyItemRoutineModel extends DailyItemModel {
  final RoutineModel routine;
  final List<TaskWithEntryModel> tasks;

  DailyItemRoutineModel({required this.routine, required this.tasks});

  /// Returns `true` only if all tasks have an entry and are completed
  bool get isCompleted {
    if (tasks.isEmpty) return false;
    return tasks.every((task) => task.entry?.completed == true);
  }

  /// Returns progress as a double between 0 and 1
  double get progress {
    if (tasks.isEmpty) return 0.0;

    final completedCount = tasks
        .where((task) => task.entry?.completed == true)
        .length;

    return completedCount / tasks.length;
  }
}
