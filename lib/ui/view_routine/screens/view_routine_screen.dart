import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/config/app_icons.dart';
import 'package:mobile/domain/models/task_model.dart';
import 'package:mobile/ui/view_routine/bloc/view_routine_bloc.dart';
import 'package:mobile/ui/view_routine/screens/new_routine_task_screen.dart';
import 'package:mobile/ui/view_routine/screens/view_routine_task_screen.dart';
import 'package:mobile/ui/view_routine/widgets/routine_task_duration.dart';
import 'package:mobile/utils/app_logger.dart';

class ViewRoutineScreen extends StatelessWidget {
  ViewRoutineScreen({super.key});

  final logger = AppLogger.tag("ViewRoutineScreen");

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViewRoutineBloc, ViewRoutineState>(
      builder: (context, state) {
        if (state is ViewRoutineLoaded) {
          final routine = state.routine;
          final theme = Theme.of(context);
          final tasks = state.tasks;

          return Scaffold(
            appBar: AppBar(),
            floatingActionButton: OutlinedButton.icon(
              onPressed: () async {
                final bloc = context.read<ViewRoutineBloc>();
                final newTask = await Navigator.push<TaskModel>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NewRoutineTaskScreen(),
                  ),
                );

                if (newTask != null) {
                  bloc.add(ViewRoutineNewTaskAdded(newTask));
                }
              },
              icon: Icon(Icons.add),
              label: const Text("New Task"),
            ),
            body: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    routine.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Start Time : ${routine.startTime.format(context)}",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w200,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Tasks', style: theme.textTheme.labelLarge),
                      OutlinedButton.icon(
                        onPressed: () {
                          logger.debug("Start Task Clicked");
                        },
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Start Routine"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: tasks.isNotEmpty
                        ? ListView.separated(
                            itemCount: tasks.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return Dismissible(
                                key: Key(task.id),
                                background: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.errorContainer,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: theme.colorScheme.onErrorContainer,
                                  ),
                                ),
                                secondaryBackground: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.errorContainer,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: theme.colorScheme.onErrorContainer,
                                  ),
                                ),
                                onDismissed: (direction) {
                                  context.read<ViewRoutineBloc>().add(
                                    ViewRoutineTaskRemoved(task),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor:
                                          theme.colorScheme.errorContainer,
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: theme
                                                .colorScheme
                                                .onErrorContainer,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              'Task removed.',
                                              style: TextStyle(
                                                color: theme
                                                    .colorScheme
                                                    .onErrorContainer,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    backgroundColor: theme
                                        .colorScheme
                                        .surfaceContainerHighest, // Set here
                                  ),
                                  onPressed: () async {
                                    final bloc = context
                                        .read<ViewRoutineBloc>();

                                    final updatedTask =
                                        await Navigator.of(
                                          context,
                                        ).push<TaskModel>(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ViewRoutineTaskScreen(
                                                  task: task,
                                                ),
                                          ),
                                        );
                                    if (updatedTask != null) {
                                      bloc.add(
                                        ViewRoutineTaskUpdated(updatedTask),
                                      );
                                    }
                                  },
                                  child: Ink(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                AppIcons.icons[task.iconIndex],
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                task.title,
                                                style:
                                                    theme.textTheme.bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                formatTaskDuration(
                                                  task.duration,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Checkbox(
                                                value: task.isCompleted,
                                                side: BorderSide(
                                                  color: theme
                                                      .colorScheme
                                                      .primary
                                                      .withValues(alpha: 0.7),
                                                ),
                                                shape: const CircleBorder(),
                                                onChanged: (value) {
                                                  context
                                                      .read<ViewRoutineBloc>()
                                                      .add(
                                                        ViewRoutineTaskUpdated(
                                                          task.copyWith(
                                                            isCompleted: value,
                                                          ),
                                                        ),
                                                      );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'Empty Task List',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is ViewRoutineError) {
          return Scaffold(body: Center(child: const Text("Something's wrong")));
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
      listener: (context, state) {},
    );
  }
}
