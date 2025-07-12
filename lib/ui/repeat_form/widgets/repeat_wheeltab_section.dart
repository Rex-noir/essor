import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheel_picker/wheel_picker.dart';

class RepeatWheeltabSection extends StatelessWidget {
  final String title;
  final List<int> intervals;
  final int selectedIndex;
  final String Function(int) labelBuilder;
  final void Function(int) onChanged;
  final double height;
  final DateTime startDate;
  final ValueChanged<DateTime> onStartDateChanged;

  const RepeatWheeltabSection({
    super.key,
    required this.title,
    required this.intervals,
    required this.selectedIndex,
    required this.labelBuilder,
    required this.onChanged,
    this.height = 300,
    required this.startDate,
    required this.onStartDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      spacing: 32,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(
          height: height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              WheelPicker(
                itemCount: intervals.length,
                looping: false,
                onIndexChanged: (i, _) {
                  HapticFeedback.selectionClick();
                  onChanged(i);
                },
                builder: (context, i) => Container(
                  alignment: Alignment.center,
                  child: Text(
                    labelBuilder(intervals[i]),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                style: const WheelPickerStyle(
                  itemExtent: 52,
                  squeeze: 0.85,
                  diameterRatio: 100,
                  magnification: 1.25,
                  surroundingOpacity: 0.35,
                ),
                initialIndex: selectedIndex,
                selectedIndexColor: colorScheme.primary,
              ),
              // Indicator lines
              Positioned(
                top: height * 0.5 - 25,
                left: 32,
                right: 32,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.15),
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: 0.15),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: height * 0.5 + 25,
                left: 32,
                right: 32,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.15),
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: 0.15),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
