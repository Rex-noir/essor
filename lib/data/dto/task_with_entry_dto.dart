import 'package:mobile/database/database.dart';
import 'package:mobile/database/tables/task_entries_table.dart';
import 'package:mobile/database/tables/tasks_table.dart';
import 'package:mobile/domain/models/task_with_entry_model.dart';

class TaskWithEntryDto {
  final Task task;
  final TaskEntry? entry;

  const TaskWithEntryDto(this.task, this.entry);

  TaskWithEntryModel toModel() =>
      TaskWithEntryModel(task: task.toModel(), entry: entry?.toModel());

  factory TaskWithEntryDto.fromModel(TaskWithEntryModel model) =>
      TaskWithEntryDto(
        Task(
          id: model.task.id,
          routineId: model.task.routineId,
          title: model.task.title,
          description: model.task.description,
          iconIndex: model.task.iconIndex,
          order: model.task.order,
          duration: model.task.duration,
        ),
        model.entry != null
            ? TaskEntry(
                id: model.entry!.id,
                taskId: model.entry!.taskId,
                entryDate: model.entry!.entryDate,
                completed: model.entry!.completed,
              )
            : null,
      );
}
