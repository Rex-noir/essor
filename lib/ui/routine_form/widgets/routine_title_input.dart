import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/ui/routine_form/bloc/routine_form_bloc.dart';
import 'package:mobile/utils/app_logger.dart';

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
  late RoutineFormBloc _bloc;

  final logger = TaggedLogger("RoutineTitleInput");

  @override
  void initState() {
    super.initState();
    _bloc = context.read<RoutineFormBloc>();
    _controller = TextEditingController(text: _bloc.state.title);

    _controller.addListener(() {
      final text = _controller.text;
      if (text != _bloc.state.title) {
        _bloc.add(RoutineFormTitileUpdated(text));
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final blocTitle = _bloc.state.title;
    if (blocTitle != _controller.text) {
      _controller.text = blocTitle;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoutineFormBloc, RoutineFormState>(
      listenWhen: (previous, current) => previous.title != current.title,
      listener: (context, state) {
        if (_controller.text != state.title) {
          _controller.text = state.title;
        }
      },
      child: Container(
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
      ),
    );
  }
}
