import 'package:flutter/material.dart';
import 'package:mobile/domain/enums/day_of_week.dart';

class RoutineRepeatDays extends StatefulWidget {
  final Set<DayOfWeek> initialSelected;
  final void Function(Set<DayOfWeek>)? onSelectionChanged;

  const RoutineRepeatDays({
    super.key,
    this.initialSelected = const {},
    this.onSelectionChanged,
  });

  @override
  State<RoutineRepeatDays> createState() => _RoutineRepeatDaysState();
}

class _RoutineRepeatDaysState extends State<RoutineRepeatDays> {
  late Set<DayOfWeek> selectedDays;

  @override
  void initState() {
    super.initState();
    selectedDays = Set.from(widget.initialSelected);
  }

  void toggleSelection(DayOfWeek day) {
    setState(() {
      if (selectedDays.contains(day)) {
        selectedDays.remove(day);
      } else {
        selectedDays.add(day);
      }
      if (widget.onSelectionChanged != null) {
        widget.onSelectionChanged!(selectedDays);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
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

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => toggleSelection(day),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
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
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
