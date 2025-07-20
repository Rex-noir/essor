import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/config/app_icons.dart';
import 'package:mobile/domain/enums/item_type.dart';
import 'package:mobile/domain/repositories/habit_repository.dart';
import 'package:mobile/ui/daily_items/models/daily_item_habit_model.dart';
import 'package:mobile/ui/view_habit/blocs/view_habit_bloc.dart';
import 'package:mobile/ui/view_habit/models/view_habit_model.dart';
import 'package:mobile/ui/view_habit/screens/view_habit_screen.dart';

class HabitListItem extends StatelessWidget {
  final DailyItemHabitModel model;
  final DateTime date;

  const HabitListItem({required this.model, required this.date, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final habit = model.habit;
    final progress = model.progress;

    // Dynamic color based on completion status
    final habitColor = progress.completed ? Colors.green : Colors.amberAccent;

    final surfaceColor = isDark
        ? colorScheme.surface.withValues(alpha: 0.6)
        : colorScheme.surface;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (_) => ViewHabitBloc(context.read<HabitRepository>())
                    ..add(
                      ViewHabitStarted(
                        ViewHabitModel(habit: model.habit, entry: model.entry),
                        date,
                      ),
                    ),
                  child: ViewHabitScreen(),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon at top left
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: habitColor.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    AppIcons.getIcon(habit.iconIndex),
                    color: habitColor,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 16),

                // Content area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        habit.title,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Progress text
                      Text(
                        progress.text,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 12,
                          letterSpacing: 0.1,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Habit type badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: habitColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'HABIT',
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 9,
                            color: habitColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Status indicator on the right
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Status icon or percentage
                    if (habit.habitType == ItemType.binary)
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Icon(
                          progress.completed
                              ? Icons.check
                              : Icons.radio_button_unchecked,
                          color: progress.completed
                              ? Colors.green.shade600
                              : colorScheme.onSurface.withValues(alpha: 0.4),
                          size: 16,
                        ),
                      )
                    else
                      // Circular progress for quantitative habits
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: Stack(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                            ),
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(
                                value: progress.value,
                                strokeWidth: 2,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  habitColor.withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              child: Text(
                                "${(progress.value * 100).toInt()}%",
                                style: textTheme.bodySmall?.copyWith(
                                  fontSize: 8,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
