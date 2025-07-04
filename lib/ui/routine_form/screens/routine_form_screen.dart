import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/config/app_icons.dart';
import 'package:mobile/core/ui/widgets/show_icon_picker.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/repositories/task_repository.dart';
import 'package:mobile/domain/usecases/create_new_task_usecase.dart';
import 'package:mobile/domain/usecases/get_tasks_with_entry_usecase.dart';
import 'package:mobile/domain/usecases/update_task_with_entry_usecase.dart';
import 'package:mobile/ui/routine_form/bloc/routine_form_bloc.dart';
import 'package:mobile/ui/routine_form/widgets/repeat_section_card.dart';
import 'package:mobile/ui/routine_form/widgets/routine_title_input.dart';
import 'package:mobile/ui/view_routine/bloc/view_routine_bloc.dart';
import 'package:mobile/ui/view_routine/screens/view_routine_screen.dart';

class RoutineFormScreen extends StatelessWidget {
  const RoutineFormScreen({super.key});

  void onRoutineSubmit({
    required BuildContext context,
    required RoutineModel routine,
    required RoutineFormMode mode,
  }) async {
    final taskRepo = context.read<TaskRepository>();
    if (mode == RoutineFormMode.edit) {
      Navigator.pop(context);
    }
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<ViewRoutineBloc>(
          create: (context) => ViewRoutineBloc(
            getTasksWithEntryUsecase: GetTasksWithEntryUsecase(taskRepo),
            createNewTaskUsecase: CreateNewTaskUsecase(taskRepo),
            updateTaskWithEntryUsecase: UpdateTaskWithEntryUsecase(taskRepo),
          )..add(ViewRoutineStarted(routine, routine.startDate)),
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<RoutineFormBloc, RoutineFormState>(
          buildWhen: (prev, curr) => prev.mode != curr.mode,
          builder: (context, state) {
            return _buildAppBar(
              context,
              Theme.of(context).colorScheme,
              state.mode == RoutineFormMode.create
                  ? "New Routine"
                  : "Edit Routine",
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const SizedBox(height: 32),
            RoutineTitleInput(context: context, theme: theme),
            const SizedBox(height: 32),
            _buildRepeatCard(context),
            const SizedBox(height: 24),
            _buildTimeOfDayPicker(context),
            const SizedBox(height: 24),
            _buildActionButtons(context, theme),
          ],
        ),
      ),
    );
  }

  _buildRepeatCard(BuildContext context) {
    return BlocBuilder<RoutineFormBloc, RoutineFormState>(
      builder: (context, state) {
        return RepeatSectionCard(
          selectedFrequency: state.selectedFrequency,
          interval: state.interval,
          weeklyDays: state.weeklyDays,
          startDate: state.startDate,
          onRepeatSettingsChanged:
              ({
                required ItemFrequency frequency,
                required int interval,
                required List<int> weeklyDays,
              }) {
                context.read<RoutineFormBloc>().add(
                  RoutineFormFrequencyUpated(frequency),
                );
                context.read<RoutineFormBloc>().add(
                  RoutineFormIntervalUpdated(interval),
                );
                context.read<RoutineFormBloc>().add(
                  RoutineFormWeeklyDaysUpdated(weeklyDays),
                );
              },
          onWeeklyDaysChanged: (selectedDays) {
            context.read<RoutineFormBloc>().add(
              RoutineFormWeeklyDaysUpdated(selectedDays),
            );
          },
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ColorScheme colorScheme,
    String label,
  ) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        label,
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
    return BlocBuilder<RoutineFormBloc, RoutineFormState>(
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
                  final bloc = context.read<RoutineFormBloc>();
                  final icon = await showIconPicker(
                    context,
                    AppIcons.categorizedIcons,
                  );

                  if (icon != null) {
                    bloc.add(RoutineFormIconUpdated(icon));
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
          child: BlocBuilder<RoutineFormBloc, RoutineFormState>(
            buildWhen: (previous, current) => previous.title != current.title,
            builder: (context, state) {
              final isValid = state.title.trim().isNotEmpty;

              return ElevatedButton(
                onPressed: isValid
                    ? () {
                        context.read<RoutineFormBloc>().add(
                          RoutineFormSubmitRequested(
                            onSubmit:
                                ({
                                  required RoutineModel routine,
                                  required RoutineFormMode mode,
                                }) {
                                  onRoutineSubmit(
                                    context: context,
                                    mode: mode,
                                    routine: routine,
                                  );
                                },
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
                child: Text(
                  state.mode == RoutineFormMode.create
                      ? "Create Routine"
                      : "Save Routine",
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
            final bloc = context.read<RoutineFormBloc>();
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (picked != null) {
              bloc.add(RoutineFormStartTimeUpdated(picked));
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
                      BlocBuilder<RoutineFormBloc, RoutineFormState>(
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
