import 'package:mobile/database/database.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/models/task_model.dart';
import 'package:mobile/domain/models/task_with_entry_model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> fetchTasksforDate(DateTime date);

  Future<List<TaskWithEntryModel>> fetchTasksForRoutine(
    RoutineModel routine,
    DateTime date,
  );

  Future<TaskWithEntryModel> createNewTask(TaskWithEntryModel task);

  Future<TaskWithEntryModel> updateTask(TaskModel task);

  Future<TaskEntry> updateEntry(TaskEntry entry);

  Future<List<TaskModel>> reorderTasks(List<TaskModel> tasks);
}
