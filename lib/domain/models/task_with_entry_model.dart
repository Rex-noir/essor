import 'package:mobile/domain/models/task_entry_model.dart';
import 'package:mobile/domain/models/task_model.dart';

class TaskWithEntryModel {
  final TaskModel task;
  final TaskEntryModel? entry;

  const TaskWithEntryModel({required this.task, required this.entry});

  TaskWithEntryModel copyWith({TaskModel? task, TaskEntryModel? entry}) {
    return TaskWithEntryModel(
      task: task ?? this.task,
      entry: entry ?? this.entry,
    );
  }

  @override
  String toString() {
    return 'TaskWithEntryModel(task: ${task.toString()}, entry: ${entry.toString()})';
  }
}
