import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile/ui/new_routine/bloc/new_routine_bloc.dart';
import 'package:wheel_picker/wheel_picker.dart';

class RepeatWheeltabSection extends StatelessWidget {
  final String title;
  final List<int> intervals;
  final int selectedIndex;
  final String Function(int) labelBuilder;
  final void Function(int) onChanged;
  final double height;

  const RepeatWheeltabSection({
    super.key,
    required this.title,
    required this.intervals,
    required this.selectedIndex,
    required this.labelBuilder,
    required this.onChanged,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bloc = context.read<NewRoutineBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Container(
            height: height,
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                WheelPicker(
                  itemCount: intervals.length,
                  looping: false,
                  onIndexChanged: (i, _) => onChanged(i),
                  builder: (context, i) => Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      labelBuilder(intervals[i]),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  style: const WheelPickerStyle(
                    itemExtent: 50,
                    squeeze: 0.8,
                    diameterRatio: 1000,
                    surroundingOpacity: 0.5,
                    magnification: 1.2,
                  ),
                  initialIndex: selectedIndex,
                  selectedIndexColor: colorScheme.primary,
                ),
                Positioned(
                  top: height * 0.4,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    color: colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                Positioned(
                  top: height * 0.6,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    color: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () async {
              final newDate = await showDatePicker(
                context: context,
                initialDate: bloc.state.startDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
              );
              if (newDate != null) {
                bloc.add(UpdateStartDateNewRoutineEvent(newDate));
              }
            },
            icon: const Icon(Icons.calendar_today, size: 18),
            label: Text(
              'Start: ${DateFormat('MMM d, y').format(bloc.state.startDate)}',
              style: const TextStyle(fontSize: 14),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
