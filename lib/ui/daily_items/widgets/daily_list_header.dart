import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/ui/daily_items/bloc/daily_list_bloc.dart';

class DailyListHeader extends StatelessWidget {
  const DailyListHeader({
    super.key,
    required Animation<double> fadeAnimation,
    required this.context,
    required this.state,
  }) : _fadeAnimation = fadeAnimation;
  final Animation<double> _fadeAnimation;
  final BuildContext context;
  final DailyListState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Daily Items",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          if (state is DailyListLoaded) ...[
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                DateFormat.yMMMMEEEEd().format(
                  (state as DailyListLoaded).selectedDate,
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          ] else
            Text(
              DateFormat.yMMMMEEEEd().format(DateTime.now()),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
        ],
      ),
    );
  }
}
