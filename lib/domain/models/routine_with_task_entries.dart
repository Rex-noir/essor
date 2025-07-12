import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/models/task_with_entry_model.dart';

class RoutineWithTaskEntries {
  final RoutineModel routine;
  final List<TaskWithEntryModel> tasks;

  RoutineWithTaskEntries({required this.routine, required this.tasks});
}
