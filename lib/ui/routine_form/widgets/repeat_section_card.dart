import 'package:flutter/material.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/ui/routine_form/widgets/routine_repeat_days.dart';
import 'package:mobile/ui/routine_form/screens/repeat_full_screen.dart'; // Ensure this import is correct
import 'package:mobile/utils/item_util.dart'; // Ensure this import is correct

// Define a type for the callback when repeat settings change
typedef OnRepeatSettingsChanged =
    void Function({
      required ItemFrequency frequency,
      required int interval,
      required List<int> weeklyDays,
    });

class RepeatSectionCard extends StatelessWidget {
  final ItemFrequency selectedFrequency;
  final int interval;
  final List<int> weeklyDays;
  final DateTime startDate;
  final OnRepeatSettingsChanged onRepeatSettingsChanged;
  final ValueChanged<List<int>> onWeeklyDaysChanged;

  const RepeatSectionCard({
    super.key,
    required this.selectedFrequency,
    required this.interval,
    required this.weeklyDays,
    required this.startDate,
    required this.onRepeatSettingsChanged,
    required this.onWeeklyDaysChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _buildRepeatSection(context, theme);
  }

  Widget _buildRepeatSection(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(
              alpha: .1,
            ), // Use withOpacity
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: 0.1,
          ), // Use withOpacity
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Removed `spacing` as it's not a direct property of Column.
        // If you need spacing between children, use SizedBox or Gap.
        children: [
          _buildRepeatHeader(context, theme),
          const SizedBox(height: 8), // Added SizedBox for spacing
          _buildRepeatContent(context, theme),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  // TODO: Implement calendar preview
                },
                icon: Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                label: Text(
                  "Preview",
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatHeader(BuildContext context, ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          // Navigate to RepeatFullScreen and expect a result
          final returned = await Navigator.push<RepeatSettingsResult>(
            context,
            MaterialPageRoute(
              builder: (_) => RepeatFullScreen(
                initialFrequency: selectedFrequency,
                initialInterval: interval,
                initialWeeklyDays: weeklyDays,
                initialStartDate: startDate,
              ),
            ),
          );
          if (returned != null) {
            onRepeatSettingsChanged(
              frequency: returned.frequency,
              interval: returned.interval,
              weeklyDays: returned.weeklyDays,
            );
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.repeat_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Repeat",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      getFrequencyIntervalLabel(
                        selectedFrequency, // Use parameter
                        interval, // Use parameter
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withValues(
                  alpha: 0.6,
                ), // Use withOpacity
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRepeatContent(BuildContext context, ThemeData theme) {
    // This part now uses the parameters directly.
    if (selectedFrequency == ItemFrequency.daily) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: theme.colorScheme.outline.withValues(
            alpha: 0.3,
          ), // Use withOpacity
          height: 1,
        ),
        const SizedBox(height: 20),
        Text(
          "Select Days",
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(
              alpha: 0.8,
            ), // Use withOpacity
          ),
        ),
        const SizedBox(height: 12),
        RoutineRepeatDays(
          selectedDays: weeklyDays.toSet(), // Use parameter
          onSelectionChanged: (selectedDays) {
            onWeeklyDaysChanged(selectedDays.toList()); // Use callback
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
