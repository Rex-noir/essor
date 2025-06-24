import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/ui/habit_form/bloc/habit_form_bloc.dart';

class HabitFormTargetValueField extends StatefulWidget {
  const HabitFormTargetValueField({
    super.key,
    required this.colorScheme,
    required this.textTheme,
    required this.value,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final int? value;

  @override
  State<HabitFormTargetValueField> createState() =>
      _HabitFormTargetValueFieldState();
}

class _HabitFormTargetValueFieldState extends State<HabitFormTargetValueField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value?.toString() ?? '');
  }

  @override
  void didUpdateWidget(HabitFormTargetValueField oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newValue = widget.value?.toString() ?? '';
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
          "Target Value",
          style: widget.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: widget.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "e.g., 10",
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
              Icons.numbers,
              color: widget.colorScheme.onSurfaceVariant,
            ),
          ),
          style: widget.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          onChanged: (value) {
            final parsed = int.tryParse(value);
            context.read<HabitFormBloc>().add(
              HabitFormTargetValueUpdated(parsed),
            );
          },
        ),
      ],
    );
  }
}
