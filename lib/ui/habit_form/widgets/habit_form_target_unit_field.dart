import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/ui/habit_form/bloc/habit_form_bloc.dart';

class HabitFormTargetUnitField extends StatefulWidget {
  const HabitFormTargetUnitField({
    super.key,
    required this.colorScheme,
    required this.textTheme,
    required this.value,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final String? value;

  @override
  State<HabitFormTargetUnitField> createState() =>
      _HabitFormTargetUnitFieldState();
}

class _HabitFormTargetUnitFieldState extends State<HabitFormTargetUnitField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(HabitFormTargetUnitField oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newValue = widget.value ?? '';
    if (_controller.text != newValue) {
      _controller.text = newValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Unit of Measurement",
          style: widget.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: widget.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: "e.g., minutes, steps, glasses",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: widget.colorScheme.surfaceContainerHighest,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            prefixIcon: Icon(
              Icons.label_outline,
              color: widget.colorScheme.onSurfaceVariant,
            ),
          ),
          onChanged: (value) => context.read<HabitFormBloc>().add(
            HabitFormTargetUnitUpdated(value.isEmpty ? null : value),
          ),
        ),
      ],
    );
  }
}
