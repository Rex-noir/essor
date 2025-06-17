import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/domain/entities/routine_enitity.dart';
import 'package:mobile/domain/entities/task_entity.dart';

part 'view_routine_event.dart';
part 'view_routine_state.dart';

class ViewRoutineBloc extends Bloc<ViewRoutineEvent, ViewRoutineState> {
  ViewRoutineBloc() : super(ViewRoutineInitial()) {
    on<ViewRoutineStarted>(_onViewRoutineStarted);
    on<ViewRoutineTaskUpdated>(_onViewRoutineTaskUpdated);
    on<ViewRoutineNewTaskAdded>(_onNewTaskAdded);
    on<ViewRoutineTaskRemoved>(_onViewRoutineRemoved);
  }

  FutureOr<void> _onViewRoutineStarted(
    ViewRoutineStarted event,
    Emitter<ViewRoutineState> emit,
  ) {
    emit(ViewRoutineLoaded(routine: event.routine));

    // If wanted load the routine once more form the api server
  }

  _onNewTaskAdded(
    ViewRoutineNewTaskAdded event,
    Emitter<ViewRoutineState> emit,
  ) {
    if (state is! ViewRoutineLoaded) {
      return;
    }
    final currentState = state as ViewRoutineLoaded;
    final newRoutine = currentState.routine.addTask(event.task);
    emit(ViewRoutineLoaded(routine: newRoutine));
  }

  _onViewRoutineTaskUpdated(
    ViewRoutineTaskUpdated event,
    Emitter<ViewRoutineState> emit,
  ) {
    if (state is! ViewRoutineLoaded) {
      return;
    }

    final currentState = state as ViewRoutineLoaded;

    final newRoutine = currentState.routine.updateTask(event.task);
    emit(ViewRoutineLoaded(routine: newRoutine));
  }

  _onViewRoutineRemoved(
    ViewRoutineTaskRemoved event,
    Emitter<ViewRoutineState> emit,
  ) {
    if (state is! ViewRoutineLoaded) {
      return;
    }

    final currentState = state as ViewRoutineLoaded;

    final newRoutine = currentState.routine.removeTask(event.task.id);
    emit(ViewRoutineLoaded(routine: newRoutine));
  }
}
