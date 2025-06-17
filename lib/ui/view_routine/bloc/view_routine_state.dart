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
  final RoutineEntity routine;
  const ViewRoutineLoaded({required this.routine});

  @override
  List<Object?> get props => [routine];
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
