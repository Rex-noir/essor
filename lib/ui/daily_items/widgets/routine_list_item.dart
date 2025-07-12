import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/config/app_icons.dart';
import 'package:mobile/domain/repositories/task_repository.dart';
import 'package:mobile/ui/daily_items/bloc/daily_list_bloc.dart';
import 'package:mobile/ui/daily_items/models/daily_item_routine_model.dart';
import 'package:mobile/ui/view_routine/bloc/view_routine_bloc.dart';
import 'package:mobile/ui/view_routine/screens/view_routine_screen.dart';
import 'package:mobile/utils/item_util.dart';

class RoutineListItem extends StatelessWidget {
  final DailyItemRoutineModel model;

  const RoutineListItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // More subtle color palette
    final primaryColor = colorScheme.primary;
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
            final routineDate =
                (context.read<DailyListBloc>().state as DailyListLoaded)
                    .selectedDate;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) =>
                      ViewRoutineBloc(repo: context.read<TaskRepository>())
                        ..add(ViewRoutineStarted(model.routine, routineDate)),
                  child: ViewRoutineScreen(),
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
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withValues(alpha: 0.06),
                  ),
                  child: Icon(
                    AppIcons.getIcon(model.routine.iconIndex),
                    color: primaryColor.withValues(alpha: 0.7),
                    size: 18,
                  ),
                ),

                const SizedBox(width: 16),

                // Content area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with refined typography
                      Text(
                        model.routine.title,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 2),

                      // Frequency - more subtle
                      Text(
                        getFrequencyIntervalLabel(
                          model.routine.frequency,
                          model.routine.interval,
                        ),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: 12,
                          letterSpacing: 0.1,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Routine indicator badge - moved here
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'ROUTINE',
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 9,
                            color: primaryColor.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Circular progress indicator at top right
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: Stack(
                        children: [
                          // Percentage text
                          Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            child: Text(
                              "${(model.progress * 100).toInt()}%",
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
