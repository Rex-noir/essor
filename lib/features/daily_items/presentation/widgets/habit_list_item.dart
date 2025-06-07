import 'package:flutter/material.dart';
import 'package:mobile/features/daily_items/domain/entities/habit_entity.dart';

class HabitListItem extends StatelessWidget {
  final HabitEntity habit;
  const HabitListItem({required this.habit, super.key});

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Center(
                    child: Icon(Icons.water_drop, color: borderColor, size: 20),
                  ),
                ),
                const SizedBox(width: 8), // spacing inside group
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
                side: BorderSide(color: borderColor),
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
