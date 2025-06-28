import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/ui/routine_form/bloc/routine_form_bloc.dart';

class RoutineTitleInput extends StatefulWidget {
  const RoutineTitleInput({
    super.key,
    required this.context,
    required this.theme,
  });

  final BuildContext context;
  final ThemeData theme;

  @override
  State<RoutineTitleInput> createState() => _RoutineTitleInputState();
}

class _RoutineTitleInputState extends State<RoutineTitleInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final title = context.read<RoutineFormBloc>().state.title;
    _controller = TextEditingController(text: title);
    _controller.addListener(() {
      context.read<RoutineFormBloc>().add(
        RoutineFormTitileUpdated(_controller.text),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.3,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Enter routine name...',
          hintStyle: TextStyle(
            color: widget.theme.colorScheme.onSurface.withValues(alpha: .5),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
          prefixIcon: Icon(
            Icons.edit_outlined,
            color: widget.theme.colorScheme.primary,
          ),
        ),
        style: widget.theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.left,
        autofocus: false,
        textCapitalization: TextCapitalization.words,
      ),
    );
  }
}
