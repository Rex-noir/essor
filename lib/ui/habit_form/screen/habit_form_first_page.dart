import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/ui/habit_form/bloc/habit_form_bloc.dart';
import 'package:mobile/ui/habit_form/widgets/habit_form_start_time.dart';
import 'package:mobile/ui/habit_form/widgets/habit_icon_picker.dart';
import 'package:mobile/ui/habit_form/widgets/habit_title_input.dart';
import 'package:mobile/ui/routine_form/widgets/repeat_section_card.dart';

class HabitFormFirstPage extends StatelessWidget {
  const HabitFormFirstPage({
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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HabitIconPicker(iconIndex: state.iconIndex),
          const SizedBox(height: 32),
          HabitTitleInput(colorScheme: colorScheme, textTheme: textTheme),
          const SizedBox(height: 24),
          RepeatSectionCard(
            selectedFrequency: state.frequency,
            interval: state.interval,
            weeklyDays: state.weeklyDays,
            startDate: state.startDate,
            onRepeatSettingsChanged:
                ({
                  required ItemFrequency frequency,
                  required int interval,
                  required List<int> weeklyDays,
                }) {
                  context.read<HabitFormBloc>().add(
                    HabitFormFrequencyUpdated(frequency),
                  );
                  context.read<HabitFormBloc>().add(
                    HabitFormIntervalUpdated(interval),
                  );
                  context.read<HabitFormBloc>().add(
                    HabitFormWeeklyDaysUpdated(weeklyDays),
                  );
                },
            onWeeklyDaysChanged: (selectedDays) {
              context.read<HabitFormBloc>().add(
                HabitFormWeeklyDaysUpdated(selectedDays),
              );
            },
          ),
          const SizedBox(height: 24),
          HabitFormStartTime(
            startTime: state.startTime,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
