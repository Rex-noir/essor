import 'package:flutter/material.dart';

import 'package:mobile/domain/enums/item_type.dart';
import 'package:mobile/ui/habit_form/bloc/habit_form_bloc.dart';
import 'package:mobile/ui/habit_form/widgets/target_summary.dart';
import 'package:mobile/ui/habit_form/widgets/operator_selector.dart';
import 'package:mobile/ui/habit_form/widgets/habit_form_target_value_field.dart';
import 'package:mobile/ui/habit_form/widgets/habit_form_target_unit_field.dart';
import 'package:mobile/ui/habit_form/widgets/habit_form_type_selector.dart';

class HabitFormSecondPage extends StatelessWidget {
  const HabitFormSecondPage({
    super.key,
    required this.context,
    required this.state,
    required this.colorScheme,
    required this.textTheme,
  });

  final BuildContext context;
  final HabitFormState state;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HabitFormTypeSelector(
            colorScheme: colorScheme,
            textTheme: textTheme,
            state: state,
          ),
          const SizedBox(height: 24),
          if (state.habitType == ItemType.quantitative)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.track_changes,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quantitative Target",
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          "Set a measurable goal for your habit",
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Target configuration in a row layout
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Goal Configuration",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Operator and Value in a row
                    Row(
                      children: [
                        // Operator dropdown
                        Expanded(
                          flex: 1,
                          child: OperatorSelector(
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                            value: state.targetOperator,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Target value
                        Expanded(
                          flex: 1,
                          child: HabitFormTargetValueField(
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                            value: state.targetValue,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Unit field
                    HabitFormTargetUnitField(
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      value: state.targetUnit,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Preview/Summary
                TargetSummary(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  targetOperator: state.targetOperator,
                  targetValue: state.targetValue,
                  targetUnit: state.targetUnit,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
