import 'package:mobile/data/dto/routine_dto.dart';
import 'package:mobile/data/dto/task_with_entry_dto.dart';
import 'package:mobile/database/daos/tasks_dao.dart';
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
      RoutineDto.fromModel(routine),
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
  Future<TaskWithEntryModel> createNewTask(
    TaskWithEntryModel task,
    DateTime date,
  ) async {
    final inserted = await tasksDao.insertTask(
      TaskWithEntryDto.fromModel(task),
    );
    return inserted.toModel();
  }

  @override
  Future<TaskWithEntryModel> updateTask(TaskWithEntryModel model) async {
    final updated = await tasksDao.updateTaskWithEntry(
      TaskWithEntryDto.fromModel(model),
    );
    return updated.toModel();
  }
}
