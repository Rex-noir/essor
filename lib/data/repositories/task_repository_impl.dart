import 'package:drift/drift.dart';
import 'package:mobile/data/dto/task_with_entry_dto.dart';
import 'package:mobile/database/daos/tasks_dao.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/database/tables/tasks_table.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/models/task_model.dart';
import 'package:mobile/domain/models/task_with_entry_model.dart';
import 'package:mobile/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TasksDao tasksDao;

  const TaskRepositoryImpl(this.tasksDao);

  @override
  Future<List<TaskWithEntryModel>> fetchTasksForRoutine(
    RoutineModel routine,
    DateTime date,
  ) async {
    final datas = await tasksDao.fetchTasksWithEntry(
      RoutineCompanion(id: Value(routine.id)),
      date,
    );
    return datas.map((dt) => dt.toModel()).toList();
  }

  @override
  Future<List<TaskModel>> fetchTasksforDate(DateTime date) {
    // TODO: implement fetchTasksforDate
    throw UnimplementedError();
  }

  @override
  Future<TaskWithEntryModel> createNewTask(TaskWithEntryModel task) async {
    final inserted = await tasksDao.insertTask(
      TaskWithEntryDto.fromModel(task),
    );
    return inserted.toModel();
  }

  @override
  Future<List<TaskModel>> reorderTasks(List<TaskModel> tasks) async {
    final updatedTasks = await tasksDao.reorderTasks(
      tasks
          .map(
            (t) => TaskCompanion(
              id: Value(t.id),
              title: Value(t.title),
              description: Value(t.description),
              iconIndex: Value(t.iconIndex),
              order: Value(t.order),
              duration: Value(t.duration),
              routineId: Value(t.routineId),
            ),
          )
          .toList(),
    );

    return updatedTasks.map((t) => t.toModel()).toList();
  }

  @override
  Future<TaskEntry> updateEntry(TaskEntry entry) {
    return tasksDao.updateTaskEntry(entry);
  }

  @override
  Future<TaskWithEntryModel> updateTask(TaskModel task) async {
    final updatedTask = await tasksDao.updateOnlyTask(task);
    return TaskWithEntryDto(updatedTask, null).toModel();
  }
}
