import 'package:flutter/material.dart';
import 'package:mobile/config/app_icons.dart';
import 'package:mobile/domain/entities/routine_enitity.dart';

class RoutineListItem extends StatelessWidget {
  final RoutineEntity routine;

  const RoutineListItem({super.key, required this.routine});

  String _repeatDaysLabel() {
    if (routine.repeatDays.length == 7) return "Everyday";
    if (routine.repeatDays.isEmpty) return "One-time";
    return routine.repeatDays.map((d) => _weekdayAbbr(d)).join(', ');
  }

  String _weekdayAbbr(int day) {
    // Dart weekday starts from Monday as 1
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[(day - 1) % 7];
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final routineColor = Colors.lightBlueAccent;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Softer corners
        side: BorderSide(color: routineColor.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: routineColor.withValues(alpha: 0.1),
                    border: Border.all(
                      color: routineColor.withValues(alpha: .3),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(routine.title, style: textTheme.titleMedium),
                    Text(
                      _repeatDaysLabel(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: color.onSurface.withValues(alpha: .6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                // Handle menu selection
                switch (value) {
                  case 'edit':
                    // Handle edit
                    break;
                  case 'delete':
                    // Handle delete
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outlined),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
              padding: EdgeInsets.zero,
              child: Icon(
                Icons.more_horiz, // Horizontal three dots
                color: color.onSurface.withValues(alpha: 0.6),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
