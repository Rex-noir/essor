import 'package:flutter/material.dart';

class RoutineTaskTitle extends StatelessWidget {
  final TextEditingController controller;

  const RoutineTaskTitle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Enter task name ...',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
          prefixIcon: Icon(
            Icons.edit_outlined,
            color: theme.colorScheme.primary,
          ),
        ),
        textAlign: TextAlign.left,
        autocorrect: false,
        textCapitalization: TextCapitalization.words,
      ),
    );
  }
}
