part of 'view_routine_bloc.dart';

sealed class ViewRoutineEvent extends Equatable {
  const ViewRoutineEvent();

  @override
  List<Object> get props => [];
}

class ViewRoutineStarted extends ViewRoutineEvent {
  final RoutineModel routine;
  final List<TaskModel> tasks;
  const ViewRoutineStarted(this.routine, this.tasks);

  @override
  List<Object> get props => [routine, tasks];
}

class ViewRoutineNewTaskAdded extends ViewRoutineEvent {
  final TaskModel task;
  const ViewRoutineNewTaskAdded(this.task);

  @override
  List<Object> get props => [task];
}

class ViewRoutineTaskUpdated extends ViewRoutineEvent {
  final TaskModel task;
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
