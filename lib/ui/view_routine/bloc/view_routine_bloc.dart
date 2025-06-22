import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/models/task_model.dart';
import 'package:mobile/domain/models/task_with_entry_model.dart';
import 'package:mobile/domain/usecases/create_new_task_usecase.dart';
import 'package:mobile/domain/usecases/get_tasks_with_entry_usecase.dart';
import 'package:mobile/domain/usecases/update_task_with_entry_usecase.dart';
import 'package:mobile/utils/app_logger.dart';

part 'view_routine_event.dart';
part 'view_routine_state.dart';

class ViewRoutineBloc extends Bloc<ViewRoutineEvent, ViewRoutineState> {
  final GetTasksWithEntryUsecase getTasksWithEntryUsecase;
  final CreateNewTaskUsecase createNewTaskUsecase;
  final UpdateTaskWithEntryUsecase updateTaskWithEntryUsecase;
  final logger = TaggedLogger("ViewRoutineBloc");
  ViewRoutineBloc({
    required this.getTasksWithEntryUsecase,
    required this.createNewTaskUsecase,
    required this.updateTaskWithEntryUsecase,
  }) : super(ViewRoutineInitial()) {
    on<ViewRoutineStarted>(_onViewRoutineStarted);
    on<ViewRoutineTaskUpdated>(_onViewRoutineTaskUpdated);
    on<ViewRoutineNewTaskAdded>(_onNewTaskAdded);
    on<ViewRoutineTaskRemoved>(_onViewRoutineTaskRemoved);
  }

  Future<void> _onViewRoutineStarted(
    ViewRoutineStarted event,
    Emitter<ViewRoutineState> emit,
  ) async {
    final tasks = await getTasksWithEntryUsecase.call(
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
    final insertedTask = await createNewTaskUsecase(
      event.task,
      event.task.entry.entryDate,
    );
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
    final newTasks = currentState.tasks.map((task) {
      if (task.task.id == event.task.task.id) {
        return event.task;
      }
      return task;
    }).toList();
    emit(currentState.copyWith(tasks: newTasks));

    final updated = await updateTaskWithEntryUsecase(event.task);
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
}
