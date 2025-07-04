import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/domain/models/task_with_entry_model.dart';
import 'package:mobile/domain/repositories/routine_repository.dart';
import 'package:mobile/domain/usecases/create_new_routine_usecase.dart';
import 'package:mobile/domain/usecases/update_routine_usecase.dart';
import 'package:mobile/ui/routine_form/bloc/routine_form_bloc.dart';
import 'package:mobile/ui/routine_form/screens/routine_form_screen.dart';
import 'package:mobile/ui/view_routine/bloc/view_routine_bloc.dart';
import 'package:mobile/ui/view_routine/screens/new_routine_task_screen.dart';
import 'package:mobile/ui/view_routine/widgets/routine_task_list.dart';
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
          final tasks = state.sortedTasks;

          return Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) =>
                                RoutineFormBloc(
                                  createNewRoutineUsecase:
                                      CreateNewRoutineUsecase(
                                        context.read<RoutineRepository>(),
                                      ),
                                  updateRoutineUsecase: UpdateRoutineUsecase(
                                    context.read<RoutineRepository>(),
                                  ),
                                )..add(
                                  RoutineFormInitial(
                                    existingModel: routine,
                                    startDate: null,
                                  ),
                                ),
                            child: const RoutineFormScreen(),
                          ),
                        ),
                      );
                    },
                    child: const Text("Edit"),
                  ),
                ),
              ],
            ),
            floatingActionButton: OutlinedButton.icon(
              onPressed: () async {
                final bloc = context.read<ViewRoutineBloc>();
                final newTask = await Navigator.push<TaskWithEntryModel>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NewRoutineTaskScreen(routineId: routine.id),
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
                        ? RoutineTaskList(
                            tasks: tasks,
                            theme: theme,
                            onReorderCompleted: (reorderedTasks) {
                              context.read<ViewRoutineBloc>().add(
                                ViewRoutineTaskOnReorder(reorderedTasks),
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
