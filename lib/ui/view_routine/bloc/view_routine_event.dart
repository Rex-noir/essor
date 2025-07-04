part of 'view_routine_bloc.dart';

sealed class ViewRoutineEvent extends Equatable {
  const ViewRoutineEvent();

  @override
  List<Object> get props => [];
}

class ViewRoutineStarted extends ViewRoutineEvent {
  final RoutineModel routine;
  final DateTime date;
  const ViewRoutineStarted(this.routine, this.date);

  @override
  List<Object> get props => [routine, date];
}

class ViewRoutineNewTaskAdded extends ViewRoutineEvent {
  final TaskWithEntryModel task;
  const ViewRoutineNewTaskAdded(this.task);

  @override
  List<Object> get props => [task];
}

class ViewRoutineTaskUpdated extends ViewRoutineEvent {
  final TaskWithEntryModel task;
  const ViewRoutineTaskUpdated(this.task);

  @override
  List<Object> get props => [task];
}

class ViewRoutineTaskRemoved extends ViewRoutineEvent {
  final TaskModel task;
  const ViewRoutineTaskRemoved(this.task);

  @override
  List<Object> get props => [task];
}

class ViewRoutineTaskOnReorder extends ViewRoutineEvent {
  final List<TaskWithEntryModel> reorderedTasks;

  const ViewRoutineTaskOnReorder(this.reorderedTasks);

  @override
  List<Object> get props => [reorderedTasks];
}
