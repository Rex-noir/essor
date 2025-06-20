part of 'view_routine_bloc.dart';

sealed class ViewRoutineState extends Equatable {
  const ViewRoutineState();

  @override
  List<Object?> get props => [];
}

class ViewRoutineLoading extends ViewRoutineState {}

class ViewRoutineInitial extends ViewRoutineState {
  const ViewRoutineInitial();
}

class ViewRoutineLoaded extends ViewRoutineState {
  final RoutineModel routine;
  final List<TaskModel> tasks;
  const ViewRoutineLoaded({required this.routine, required this.tasks});

  @override
  List<Object?> get props => [routine, tasks];

  ViewRoutineLoaded copyWith({RoutineModel? routine, List<TaskModel>? tasks}) {
    return ViewRoutineLoaded(
      routine: routine ?? this.routine,
      tasks: tasks ?? this.tasks,
    );
  }
}

class ViewRoutineError extends ViewRoutineState {
  final String message;
  const ViewRoutineError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ViewRoutineSuccess extends ViewRoutineState {
  final String message; // e.g., "Routine created successfully"
  const ViewRoutineSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
