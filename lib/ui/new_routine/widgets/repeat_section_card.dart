import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/domain/entities/habit_entity.dart';
import 'package:mobile/domain/entities/routine_enitity.dart';
import 'package:mobile/ui/new_routine/bloc/new_routine_bloc.dart';
import 'package:mobile/ui/new_routine/screens/repeat_full_screen.dart';
import 'package:mobile/ui/new_routine/widgets/routine_repeat_days.dart';

class RepeatSectionCard extends StatelessWidget {
  const RepeatSectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _buildRepeatSection(context, theme);
  }

  Widget _buildRepeatSection(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          _buildRepeatHeader(context, theme),
          _buildRepeatContent(context, theme),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  // TODO: Implement calendar preview
                },
                icon: Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                label: Text(
                  "Preview",
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatHeader(BuildContext context, ThemeData theme) {
    final bloc = context.read<NewRoutineBloc>();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final returned = await Navigator.push<RepeatSettingsResult>(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: bloc,
                child: RepeatFullScreen(
                  initialFrequency: bloc.state.selectedFrequency,
                  initialInterval: bloc.state.interval,
                  initialWeeklyDays: bloc.state.weeklyDays,
                ),
              ),
            ),
          );
          if (returned != null) {
            bloc.add(ChangeFrequencyNewRoutineEvent(returned.frequency));
            bloc.add(UpdateIntervalNewRoutineEvent(returned.interval));
            bloc.add(UpdateWeeklyDaysNewRoutineEvent(returned.weeklyDays));
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.repeat_rounded,
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
                      "Repeat",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    BlocBuilder<NewRoutineBloc, NewRoutineState>(
                      buildWhen: (previous, current) =>
                          previous.selectedFrequency !=
                              current.selectedFrequency ||
                          previous.interval != current.interval,
                      builder: (context, state) {
                        return Text(
                          getRoutineRepeatLabel(
                            bloc.state.selectedFrequency,
                            bloc.state.interval,
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
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRepeatContent(BuildContext context, ThemeData theme) {
    return BlocBuilder<NewRoutineBloc, NewRoutineState>(
      buildWhen: (previous, current) =>
          previous.weeklyDays != current.weeklyDays ||
          previous.selectedFrequency != current.selectedFrequency,
      builder: (context, state) {
        if (state.selectedFrequency == ItemFrequency.daily) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              height: 1,
            ),
            const SizedBox(height: 20),
            Text(
              "Select Days",
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 12),
            RoutineRepeatDays(
              selectedDays: state.weeklyDays.toSet(),
              onSelectionChanged: (selectedDays) => context
                  .read<NewRoutineBloc>()
                  .add(UpdateWeeklyDaysNewRoutineEvent(selectedDays.toList())),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
