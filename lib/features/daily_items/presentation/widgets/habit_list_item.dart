import 'package:flutter/material.dart';
import 'package:mobile/core/config/app_icons.dart';
import 'package:mobile/features/daily_items/domain/entities/habit_entity.dart';

class HabitListItem extends StatelessWidget {
  final HabitEntity habit;

  const HabitListItem({required this.habit, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 8,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.primary, width: 1),
                  ),
                  child: Center(
                    child: Icon(
                      AppIcons.getIcon(habit.iconIndex),
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(habit.title, style: textTheme.titleSmall),
                    Text('30/480', style: textTheme.labelSmall),
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
                side: BorderSide(color: colorScheme.primary),
                padding: EdgeInsets.zero,
                minimumSize: const Size(38, 38),
              ),
              child: const Icon(Icons.add, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
