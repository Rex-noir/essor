import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/domain/enums/habit_target_operator_enum.dart';
import 'package:mobile/ui/habit_form/bloc/habit_form_bloc.dart';

class OperatorSelector extends StatelessWidget {
  const OperatorSelector({
    super.key,
    required this.colorScheme,
    required this.textTheme,
    required this.value,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final TargetOperator value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Operator",
          style: textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<TargetOperator>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          value: value,
          items: TargetOperator.values.map((op) {
            return DropdownMenuItem(
              value: op,
              child: Row(
                children: [
                  Text(
                    op.symbol,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getOperatorDescription(op),
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (op) {
            if (op != null) {
              context.read<HabitFormBloc>().add(
                HabitFormTargetOperatorUpdated(op),
              );
            }
          },
        ),
      ],
    );
  }

  String _getOperatorDescription(TargetOperator operator) {
    switch (operator) {
      case TargetOperator.greaterThanOrEqual:
        return "at least";
      case TargetOperator.lessThanOrEqual:
        return "at most";
      case TargetOperator.equalTo:
        return "exactly";
    }
  }
}
