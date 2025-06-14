import 'package:flutter/material.dart';
import 'package:mobile/domain/enums/day_of_week.dart';

class RoutineRepeatDays extends StatelessWidget {
  final void Function(Set<DayOfWeek>)? onSelectionChanged;
  final Set<DayOfWeek> selectedDays;

  const RoutineRepeatDays({
    super.key,
    required this.selectedDays,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: DayOfWeek.values.map((day) {
          final isSelected = selectedDays.contains(day);

          final backgroundColor = isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest;
          final foregroundColor = isSelected
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant;
          final borderColor = isSelected
              ? colorScheme.primary
              : colorScheme.outline;

          return GestureDetector(
            onTap: () {
              final updated = Set<DayOfWeek>.from(selectedDays);
              if (isSelected) {
                updated.remove(day);
              } else {
                updated.add(day);
              }
              onSelectionChanged?.call(updated);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: Text(
                day.shortName,
                style: textTheme.labelMedium?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
