import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/ui/habit_form/bloc/habit_form_bloc.dart';

class HabitFormStartTime extends StatelessWidget {
  final TimeOfDay startTime;

  const HabitFormStartTime({
    super.key,
    required this.startTime,
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: .1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          hoverColor: colorScheme.primary.withValues(alpha: .04),
          splashColor: colorScheme.primary.withValues(alpha: .08),
          onTap: () async {
            final bloc = context.read<HabitFormBloc>();
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (picked != null) {
              bloc.add(HabitFormStartTimeUpdated(picked));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.timer_outlined,
                    color: colorScheme.primary,
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
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        MaterialLocalizations.of(context).formatTimeOfDay(
                          startTime,
                          alwaysUse24HourFormat: false,
                        ),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
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
