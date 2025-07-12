import 'package:mobile/data/dto/task_with_entry_dto.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/models/routine_with_task_entries.dart';

class RoutineWithTaskEntriesDto {
  final RoutineModel routine;
  final List<TaskWithEntryDto> tasks;

  RoutineWithTaskEntriesDto({required this.routine, required this.tasks});

  RoutineWithTaskEntries toModel() {
    return RoutineWithTaskEntries(
      routine: routine,
      tasks: tasks.map((t) => t.toModel()).toList(),
    );
  }

  factory RoutineWithTaskEntriesDto.fromModel(RoutineWithTaskEntries model) {
    return RoutineWithTaskEntriesDto(
      routine: model.routine,
      tasks: model.tasks.map(TaskWithEntryDto.fromModel).toList(),
    );
  }
}
