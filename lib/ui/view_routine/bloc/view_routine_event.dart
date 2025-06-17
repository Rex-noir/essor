part of 'view_routine_bloc.dart';

sealed class ViewRoutineEvent extends Equatable {
  const ViewRoutineEvent();

  @override
  List<Object> get props => [];
}

class ViewRoutineStarted extends ViewRoutineEvent {
  final RoutineEntity routine;
  const ViewRoutineStarted(this.routine);

  @override
  List<Object> get props => [routine];
}

class ViewRoutineNewTaskAdded extends ViewRoutineEvent {
  final TaskEntity task;
  const ViewRoutineNewTaskAdded(this.task);

  @override
  List<Object> get props => [task];
}

class ViewRoutineTaskUpdated extends ViewRoutineEvent {
  final TaskEntity task;
  const ViewRoutineTaskUpdated(this.task);

  @override
  List<Object> get props => [task];
}

class ViewRoutineTaskRemoved extends ViewRoutineEvent {
  final TaskEntity task;
  const ViewRoutineTaskRemoved(this.task);

  @override
  List<Object> get props => [task];
}
