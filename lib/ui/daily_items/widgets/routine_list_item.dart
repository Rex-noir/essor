import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/config/app_icons.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/repositories/task_repository.dart';
import 'package:mobile/domain/usecases/create_new_task_usecase.dart';
import 'package:mobile/domain/usecases/get_tasks_with_entry_usecase.dart';
import 'package:mobile/domain/usecases/update_task_with_entry_usecase.dart';
import 'package:mobile/ui/daily_items/bloc/daily_list_bloc.dart';
import 'package:mobile/ui/view_routine/bloc/view_routine_bloc.dart';
import 'package:mobile/ui/view_routine/screens/view_routine_screen.dart';
import 'package:mobile/utils/item_util.dart';

class RoutineListItem extends StatelessWidget {
  final RoutineModel routine;

  const RoutineListItem({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final routineColor = Colors.lightBlueAccent;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: routineColor.withOpacity(0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: () {
          final routineDate =
              (context.read<DailyListBloc>().state as DailyListLoaded)
                  .selectedDate;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => ViewRoutineBloc(
                  getTasksWithEntryUsecase: GetTasksWithEntryUsecase(
                    context.read<TaskRepository>(),
                  ),
                  createNewTaskUsecase: CreateNewTaskUsecase(
                    context.read<TaskRepository>(),
                  ),
                  updateTaskWithEntryUsecase: UpdateTaskWithEntryUsecase(
                    context.read<TaskRepository>(),
                  ),
                )..add(ViewRoutineStarted(routine, routineDate)),
                child: ViewRoutineScreen(),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: routineColor.withValues(alpha: .1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  AppIcons.getIcon(routine.iconIndex),
                  color: routineColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                routine.title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                getFrequencyIntervalLabel(routine.frequency, routine.interval),
                style: textTheme.bodySmall?.copyWith(
                  color: color.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: routineColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Routine',
                    style: textTheme.labelSmall?.copyWith(
                      color: routineColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
