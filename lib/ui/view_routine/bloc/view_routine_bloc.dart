import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/models/task_model.dart';

part 'view_routine_event.dart';
part 'view_routine_state.dart';

class ViewRoutineBloc extends Bloc<ViewRoutineEvent, ViewRoutineState> {
  ViewRoutineBloc() : super(ViewRoutineInitial()) {
    on<ViewRoutineStarted>(_onViewRoutineStarted);
    on<ViewRoutineTaskUpdated>(_onViewRoutineTaskUpdated);
    on<ViewRoutineNewTaskAdded>(_onNewTaskAdded);
    on<ViewRoutineTaskRemoved>(_onViewRoutineTaskRemoved);
  }

  FutureOr<void> _onViewRoutineStarted(
    ViewRoutineStarted event,
    Emitter<ViewRoutineState> emit,
  ) {
    emit(ViewRoutineLoaded(routine: event.routine, tasks: event.tasks));

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
    final newTask = [...currentState.tasks, event.task];
    emit(currentState.copyWith(tasks: newTask));
  }

  _onViewRoutineTaskUpdated(
    ViewRoutineTaskUpdated event,
    Emitter<ViewRoutineState> emit,
  ) {
    if (state is! ViewRoutineLoaded) {
      return;
    }

    final currentState = state as ViewRoutineLoaded;

    final newTasks = currentState.tasks.map((task) {
      if (task.id == event.task.id) {
        return event.task;
      }
      return task;
    }).toList();
    emit(currentState.copyWith(tasks: newTasks));
  }

  _onViewRoutineTaskRemoved(
    ViewRoutineTaskRemoved event,
    Emitter<ViewRoutineState> emit,
  ) {
    if (state is! ViewRoutineLoaded) {
      return;
    }

    final currentState = state as ViewRoutineLoaded;
    final newTasks = currentState.tasks
        .where((task) => task.id != event.task.id)
        .toList();
    emit(currentState.copyWith(tasks: newTasks));
  }
}
