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
import 'package:mobile/utils/app_logger.dart';
import 'package:mobile/utils/item_util.dart';

class RoutineListItem extends StatelessWidget {
  final RoutineModel routine;
  // Consider adding an onPressed callback if the routine item itself is tappable
  // final VoidCallback? onPressed;
  //

  const RoutineListItem({
    super.key,
    required this.routine,
    // this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final routineColor = Colors
        .lightBlueAccent; // Consider getting this from the theme or routine data

    final logger = TaggedLogger("RoutineListItem");

    return Card(
      // The shape of the Card defines the clip behavior for the InkWell
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Softer corners
        side: BorderSide(
          color: routineColor.withValues(alpha: 0.5),
        ), // Use withOpacity
      ),
      clipBehavior: Clip
          .antiAlias, // Ensures the InkWell ripple is clipped to the Card's rounded corners
      child: InkWell(
        onTap: () {
          // logger.debug('Routine ${routine.title} tapped!');

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // You were using 'Row(spacing: 16, children: ...)'
              // 'spacing' is not a direct property of Row.
              // We'll use SizedBox for spacing between the icon and text.
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: routineColor.withValues(
                        alpha: 0.1,
                      ), // Use withOpacity
                      border: Border.all(
                        color: routineColor.withValues(
                          alpha: 0.3,
                        ), // Use withOpacity
                        width: 1,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      AppIcons.getIcon(routine.iconIndex),
                      color: color.tertiary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16), // Spacing between icon and text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(routine.title, style: textTheme.titleMedium),
                      Text(
                        getFrequencyIntervalLabel(
                          routine.frequency,
                          routine.interval,
                        ),
                        style: textTheme.bodyMedium?.copyWith(
                          color: color.onSurface.withValues(
                            alpha: 0.6,
                          ), // Use withOpacity
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // You might want to add something here for the other side of the row,
              // or just remove MainAxisAlignment.spaceBetween if it's not needed.
              // For example, an IconButton for more options:
              // IconButton(
              //   icon: Icon(Icons.more_vert),
              //   onPressed: () {
              //     // Handle more options
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
