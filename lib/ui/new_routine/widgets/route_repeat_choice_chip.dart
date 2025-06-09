import 'package:flutter/material.dart';

class RoutineRepeatChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  const RoutineRepeatChoiceChip({
    required this.label,
    this.selected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      showCheckmark: false,
      shape: const CircleBorder(),
      visualDensity: VisualDensity(horizontal: 0.0, vertical: -4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      selected: selected,
    );
  }
}
