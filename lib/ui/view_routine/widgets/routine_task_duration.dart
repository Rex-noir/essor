import 'package:flutter/material.dart';
import 'package:mobile/core/ui/widgets/show_time_of_day_picker.dart';

String formatTaskDuration(Duration duration) {
  final h = duration.inHours;
  final m = duration.inMinutes % 60;

  if (h == 0 && m == 0) return "0m";
  if (h == 0) return "${m}m";
  if (m == 0) return "${h}h";
  return "${h}h ${m}m";
}

class RoutineTaskDuration extends StatelessWidget {
  final Duration duration;
  final Function(Duration) onStartTimeChanged;

  const RoutineTaskDuration({
    super.key,
    required this.duration,
    required this.onStartTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedTime = formatTaskDuration(duration);

    return GestureDetector(
      onTap: () async {
        final selected = await showTimeOfDayPickerBottomSheet(
          context,
          initialTime: TimeOfDay(
            hour: duration.inHours % 24,
            minute: duration.inMinutes % 60,
          ),
        );

        if (selected != null) {
          final newDuration = Duration(
            hours: selected.hour,
            minutes: selected.minute,
          );
          onStartTimeChanged(newDuration);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(Icons.access_time, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                "Duration: $formattedTime",
                style: theme.textTheme.bodyLarge,
              ),
              const Spacer(),
              Icon(
                Icons.edit,
                size: 18,
                color: theme.colorScheme.primary.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
