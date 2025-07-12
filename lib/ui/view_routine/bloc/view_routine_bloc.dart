import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/models/task_entry_model.dart';
import 'package:mobile/domain/models/task_model.dart';
import 'package:mobile/domain/models/task_with_entry_model.dart';
import 'package:mobile/domain/repositories/task_repository.dart';
import 'package:mobile/utils/app_logger.dart';

part 'view_routine_event.dart';
part 'view_routine_state.dart';

class ViewRoutineBloc extends Bloc<ViewRoutineEvent, ViewRoutineState> {
  final TaskRepository _taskRepository;
  final logger = TaggedLogger("ViewRoutineBloc");

  ViewRoutineBloc({required TaskRepository repo})
    : _taskRepository = repo,
      super(ViewRoutineInitial()) {
    on<ViewRoutineStarted>(_onViewRoutineStarted);
    on<ViewRoutineTaskUpdated>(_onViewRoutineTaskUpdated);
    on<ViewRoutineNewTaskAdded>(_onNewTaskAdded);
    on<ViewRoutineTaskRemoved>(_onViewRoutineTaskRemoved);
    on<ViewRoutineTaskOnReorder>(_onViewRoutineTaskOnReorder);
    on<ViewRoutineTaskEntryUpdated>(_onViewRoutineTaskEntryUpdated);
  }

  Future<void> _onViewRoutineStarted(
    ViewRoutineStarted event,
    Emitter<ViewRoutineState> emit,
  ) async {
    final tasks = await _taskRepository.fetchTasksForRoutine(
      event.routine,
      event.date,
    );

    logger.debug("Tasks for the viewed routine $tasks");
    emit(ViewRoutineLoaded(routine: event.routine, tasks: tasks));
    // If wanted load the routine once more form the api server
  }

  _onNewTaskAdded(
    ViewRoutineNewTaskAdded event,
    Emitter<ViewRoutineState> emit,
  ) async {
    if (state is! ViewRoutineLoaded) {
      return;
    }
    final currentState = state as ViewRoutineLoaded;
    final newTask = [...currentState.tasks, event.task];
    emit(currentState.copyWith(tasks: newTask));
    final insertedTask = await _taskRepository.createNewTask(event.task);
    logger.debug("Inserted new task $insertedTask");
  }

  _onViewRoutineTaskUpdated(
    ViewRoutineTaskUpdated event,
    Emitter<ViewRoutineState> emit,
  ) async {
    if (state is! ViewRoutineLoaded) {
      return;
    }
    final currentState = state as ViewRoutineLoaded;

    final updated = await _taskRepository.updateTask(event.task);
    final newTasks = currentState.tasks.map((task) {
      if (task.task.id == updated.task.id) {
        return updated;
      }
      return task;
    }).toList();
    emit(currentState.copyWith(tasks: newTasks));

    logger.debug("Update task $updated");
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
        .where((task) => task.task.id != event.task.id)
        .toList();
    emit(currentState.copyWith(tasks: newTasks));
  }

  FutureOr<void> _onViewRoutineTaskOnReorder(
    ViewRoutineTaskOnReorder event,
    Emitter<ViewRoutineState> emit,
  ) async {
    if (state is! ViewRoutineLoaded) return;

    final currentState = state as ViewRoutineLoaded;

    emit(currentState.copyWith(tasks: event.reorderedTasks));

    final tasks = event.reorderedTasks.map((t) => t.task).toList();
    _taskRepository.reorderTasks(tasks);
  }

  Future<void> _onViewRoutineTaskEntryUpdated(
    ViewRoutineTaskEntryUpdated event,
    Emitter<ViewRoutineState> emit,
  ) async {
    if (state is! ViewRoutineLoaded) return;
    final currentState = state as ViewRoutineLoaded;

    final updated = await _taskRepository.updateEntry(event.entry);
    final newTasks = currentState.tasks.map((task) {
      if (task.task.id == updated.task.id) {
        return updated;
      }
      return task;
    }).toList();
    emit(currentState.copyWith(tasks: newTasks));
  }
}
