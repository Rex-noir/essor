import 'package:flutter/material.dart';
import 'package:mobile/core/config/app_icons.dart';
import 'package:mobile/features/daily_items/domain/entities/routine_enitity.dart';

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

    return Card(
      color: color.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: color.primary, width: 1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    AppIcons.getIcon(routine.iconIndex),
                    color: color.primary,
                    size: 20,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine.title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _repeatDaysLabel(),
                      style: textTheme.bodySmall?.copyWith(
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: color.primary),
                padding: EdgeInsets.zero,
                minimumSize: const Size(38, 38),
              ),
              child: const Icon(Icons.play_arrow, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
