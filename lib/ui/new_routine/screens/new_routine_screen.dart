import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/config/app_icons.dart';
import 'package:mobile/core/widgets/show_icon_picker.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/repositories/task_repository.dart';
import 'package:mobile/domain/usecases/create_new_task_usecase.dart';
import 'package:mobile/domain/usecases/get_tasks_with_entry_usecase.dart';
import 'package:mobile/domain/usecases/update_task_with_entry_usecase.dart';
import 'package:mobile/ui/daily_items/bloc/daily_list_bloc.dart';
import 'package:mobile/ui/new_routine/bloc/new_routine_bloc.dart';
import 'package:mobile/ui/new_routine/widgets/repeat_section_card.dart';
import 'package:mobile/ui/view_routine/bloc/view_routine_bloc.dart';
import 'package:mobile/ui/view_routine/screens/view_routine_screen.dart';

class NewRoutineScreen extends StatelessWidget {
  const NewRoutineScreen({super.key});

  void _navigateToViewRoutine(
    BuildContext context,
    RoutineModel routine,
    DateTime routineDate,
  ) {
    Navigator.pushReplacement(
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(context, colorScheme),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const SizedBox(height: 32),
            _buildTitleInput(context, theme),
            const SizedBox(height: 32),
            RepeatSectionCard(),
            const SizedBox(height: 24),
            _buildTimeOfDayPicker(context),
            const SizedBox(height: 24),
            _buildActionButtons(context, theme),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        "New Routine",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: colorScheme.onSurface),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<NewRoutineBloc, NewRoutineState>(
      buildWhen: (previous, current) => previous.iconIndex != current.iconIndex,
      builder: (context, state) {
        return Column(
          children: [
            Center(
              child: IconButton(
                icon: Icon(AppIcons.icons[state.iconIndex]),
                iconSize: 36,
                padding: const EdgeInsets.all(32),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                onPressed: () async {
                  final bloc = context.read<NewRoutineBloc>();
                  final icon = await showIconPicker(
                    context,
                    AppIcons.categorizedIcons,
                  );

                  if (icon != null) {
                    bloc.add(NewRoutineIconChanged(icon));
                  }
                },
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Build consistent habits that stick",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .7),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitleInput(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: BlocBuilder<NewRoutineBloc, NewRoutineState>(
        buildWhen: (previous, current) => previous.title != current.title,
        builder: (context, state) {
          return TextField(
            controller: TextEditingController(text: state.title)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: state.title.length),
              ),
            onChanged: (value) => context.read<NewRoutineBloc>().add(
              NewRoutineTitleChanged(value),
            ),
            decoration: InputDecoration(
              hintText: 'Enter routine name...',
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: .5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
              prefixIcon: Icon(
                Icons.edit_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
            autofocus: false,
            textCapitalization: TextCapitalization.words,
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: .3),
              ),
            ),
            child: Text(
              "Cancel",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: .7),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: BlocBuilder<NewRoutineBloc, NewRoutineState>(
            buildWhen: (previous, current) => previous.title != current.title,
            builder: (context, state) {
              final isValid = state.title.trim().isNotEmpty;

              return ElevatedButton(
                onPressed: isValid
                    ? () {
                        context.read<NewRoutineBloc>().add(
                          CreateRoutineRequested(
                            dailyListBloc: context.read<DailyListBloc>(),
                            navigateToViewRoutine: (routine, routineDate) =>
                                _navigateToViewRoutine(
                                  context,
                                  routine,
                                  routineDate,
                                ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  "Create Routine",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeOfDayPicker(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: .1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          hoverColor: theme.colorScheme.primary.withValues(alpha: .04),
          splashColor: theme.colorScheme.primary.withValues(alpha: .08),
          onTap: () async {
            final bloc = context.read<NewRoutineBloc>();
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (picked != null) {
              bloc.add(UpdateStartTimeNewRoutineEvent(picked));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.timer_outlined,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Start Time",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      BlocBuilder<NewRoutineBloc, NewRoutineState>(
                        builder: (context, state) {
                          return Text(
                            MaterialLocalizations.of(context).formatTimeOfDay(
                              state.startTime,
                              alwaysUse24HourFormat: false,
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
