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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final routineColor = Colors.lightBlueAccent;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
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
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: routineColor.withValues(alpha: 0.1),
                ),
                child: Icon(
                  AppIcons.getIcon(routine.iconIndex),
                  color: routineColor.shade700,
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine.title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      getFrequencyIntervalLabel(
                        routine.frequency,
                        routine.interval,
                      ),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: routineColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Routine',
                  style: textTheme.labelSmall?.copyWith(
                    color: routineColor.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
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
