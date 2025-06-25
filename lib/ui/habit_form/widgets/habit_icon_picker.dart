import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/config/app_icons.dart';
import 'package:mobile/core/ui/widgets/show_icon_picker.dart';
import 'package:mobile/ui/habit_form/bloc/habit_form_bloc.dart';

class HabitIconPicker extends StatelessWidget {
  final int iconIndex;
  const HabitIconPicker({required this.iconIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: IconButton(
            icon: Icon(AppIcons.icons[iconIndex]),
            iconSize: 36,
            padding: const EdgeInsets.all(32),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            onPressed: () async {
              final bloc = context.read<HabitFormBloc>();
              final icon = await showIconPicker(
                context,
                AppIcons.categorizedIcons,
              );

              if (icon != null) {
                bloc.add(HabitFormIconIndexUpdated(icon));
              }
            },
          ),
        ),  
      ],
    );
  }
}
