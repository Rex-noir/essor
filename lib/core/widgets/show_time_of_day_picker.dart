import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';

Future<TimeOfDay?> showTimeOfDayPickerBottomSheet(
  BuildContext context, {
  TimeOfDay? initialTime,
  bool showPeriod = false,
}) {
  final now = TimeOfDay.now();
  final time = initialTime ?? now;

  int selectedHour = showPeriod
      ? (time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod)
      : time.hour; // use full hour for 24h mode
  int selectedMinute = time.minute;
  bool isAm = time.period == DayPeriod.am;

  return showModalBottomSheet<TimeOfDay>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;

      Widget wheelColumn({
        required String title,
        required List<int> values,
        required int selectedIndex,
        required String Function(int) labelBuilder,
        required void Function(int) onChanged,
      }) {
        return Expanded(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    WheelPicker(
                      itemCount: values.length,
                      initialIndex: selectedIndex,
                      looping: false,
                      onIndexChanged: (index, _) => onChanged(index),
                      builder: (context, i) => Center(
                        child: Text(
                          labelBuilder(values[i]),
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      style: const WheelPickerStyle(
                        itemExtent: 48,
                        squeeze: 0.8,
                        diameterRatio: 1000,
                        surroundingOpacity: 0.5,
                        magnification: 1.2,
                      ),
                      selectedIndexColor: colorScheme.primary,
                    ),
                    Positioned(
                      top: 160 * 0.4,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        color: colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    Positioned(
                      top: 160 * 0.6,
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
            ],
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select Time", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  wheelColumn(
                    title: "Hour",
                    values: showPeriod
                        ? List.generate(12, (i) => i + 1)
                        : List.generate(24, (i) => i),
                    selectedIndex: showPeriod ? selectedHour - 1 : selectedHour,
                    labelBuilder: (val) => val.toString().padLeft(2, '0'),
                    onChanged: (index) => setState(() {
                      selectedHour = showPeriod ? index + 1 : index;
                    }),
                  ),
                  const SizedBox(width: 8),
                  wheelColumn(
                    title: "Minute",
                    values: List.generate(60, (i) => i),
                    selectedIndex: selectedMinute,
                    labelBuilder: (val) => val.toString().padLeft(2, '0'),
                    onChanged: (index) => setState(() {
                      selectedMinute = index;
                    }),
                  ),
                  if (showPeriod) ...[
                    const SizedBox(width: 8),
                    wheelColumn(
                      title: "Period",
                      values: const [0, 1],
                      selectedIndex: isAm ? 0 : 1,
                      labelBuilder: (val) => val == 0 ? "AM" : "PM",
                      onChanged: (index) => setState(() => isAm = index == 0),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  int hour = showPeriod
                      ? (selectedHour % 12) + (isAm ? 0 : 12)
                      : selectedHour;
                  final result = TimeOfDay(hour: hour, minute: selectedMinute);
                  Navigator.of(context).pop(result);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text("Set Time"),
              ),
            ],
          ),
        ),
      );
    },
  );
}
