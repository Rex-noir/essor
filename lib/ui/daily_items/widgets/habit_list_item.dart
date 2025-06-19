import 'package:flutter/material.dart';
import 'package:mobile/core/config/app_icons.dart';
import 'package:mobile/domain/entities/habit_entity.dart';

class HabitListItem extends StatelessWidget {
  final HabitEntity habit;

  const HabitListItem({required this.habit, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final habitColor = Colors.amberAccent;

    return Card(
      elevation: 0, // Soft appearance
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Softer corners
        side: BorderSide(color: habitColor.withValues(alpha: 0.5)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ), // Increased padding for larger size
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                spacing: 16, // Increased spacing
                children: [
                  Container(
                    width: 56, // Larger icon container
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: habitColor.withValues(
                        alpha: 0.1,
                      ), // Soft background
                      border: Border.all(
                        color: habitColor.withValues(alpha: .3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      AppIcons.getIcon(habit.iconIndex),
                      color: colorScheme.tertiary,
                      size: 26, // Larger icon
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.title,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '30/480',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: .6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
