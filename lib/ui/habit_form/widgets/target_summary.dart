import 'package:flutter/material.dart';
import 'package:mobile/domain/enums/habit_target_operator_enum.dart';

class TargetSummary extends StatelessWidget {
  const TargetSummary({
    super.key,
    required this.colorScheme,
    required this.textTheme,
    required this.targetOperator,
    required this.targetValue,
    required this.targetUnit,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final TargetOperator targetOperator;
  final int? targetValue;
  final String? targetUnit;

  @override
  Widget build(BuildContext context) {
    if (targetValue == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.preview, color: colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Text(
            "Goal: ",
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            "${targetOperator.symbol} $targetValue ${targetUnit ?? 'units'}",
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
