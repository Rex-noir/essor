import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/ui/habit_form/bloc/habit_form_bloc.dart';

class HabitTitleInput extends StatefulWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const HabitTitleInput({
    super.key,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  State<HabitTitleInput> createState() => _HabitTitleInputState();
}

class _HabitTitleInputState extends State<HabitTitleInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initialTitle = context.read<HabitFormBloc>().state.title;
    _controller = TextEditingController(text: initialTitle)
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: initialTitle.length),
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = widget.colorScheme;
    final textTheme = widget.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (value) =>
            context.read<HabitFormBloc>().add(HabitFormTitleUpdated(value)),
        decoration: InputDecoration(
          hintText: 'Enter habit name',
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: .5),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
          prefixIcon: Icon(Icons.edit_outlined, color: colorScheme.primary),
        ),
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
        textAlign: TextAlign.left,
        autofocus: false,
        textCapitalization: TextCapitalization.words,
      ),
    );
  }
}
