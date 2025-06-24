import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/domain/enums/item_type.dart';
import 'package:mobile/ui/habit_form/bloc/habit_form_bloc.dart';

class HabitFormTypeSelector extends StatelessWidget {
  const HabitFormTypeSelector({
    super.key,
    required this.colorScheme,
    required this.textTheme,
    required this.state,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final HabitFormState state;

  @override
  Widget build(BuildContext context) {
    String description;
    switch (state.habitType) {
      case ItemType.binary:
        description = "Track whether the habit was done or not.";
        break;
      case ItemType.quantitative:
        description =
            "Track how much of the habit was done (e.g. pages, reps, minutes).";
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Habit Type",
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: .7),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<ItemType>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: ItemType.binary,
                label: Text('Binary'),
                icon: Icon(Icons.toggle_on),
              ),
              ButtonSegment(
                value: ItemType.quantitative,
                label: Text('Quantitative'),
                icon: Icon(Icons.numbers),
              ),
            ],
            selected: {state.habitType},
            onSelectionChanged: (Set<ItemType> selection) {
              if (selection.isNotEmpty) {
                context.read<HabitFormBloc>().add(
                  HabitFormTypeUpdated(selection.first),
                );
              }
            },
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: WidgetStatePropertyAll(
                const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
