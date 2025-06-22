import 'package:mobile/database/database.dart';
import 'package:mobile/database/tables/task_entries_table.dart';
import 'package:mobile/database/tables/tasks_table.dart';
import 'package:mobile/domain/models/task_with_entry_model.dart';

class TaskWithEntryDto {
  final Task task;
  final TaskEntry entry;

  const TaskWithEntryDto(this.task, this.entry);

  TaskWithEntryModel toModel() =>
      TaskWithEntryModel(task: task.toModel(), entry: entry.toModel());

  factory TaskWithEntryDto.fromModel(TaskWithEntryModel model) =>
      TaskWithEntryDto(
        Task(
          duration: model.task.duration,
          id: model.task.id,
          routineId: model.task.routineId,
          title: model.task.title,
          description: model.task.description,
          iconIndex: model.task.iconIndex,
          importance: model.task.importance,
        ),
        TaskEntry(
          completed: model.entry.completed,
          id: model.entry.id,
          taskId: model.entry.taskId,
          entryDate: model.entry.entryDate,
        ),
      );
}
