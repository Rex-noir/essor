import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/ui/repeat_form/widgets/repeat_wheeltab_section.dart';
import 'package:mobile/ui/routine_form/widgets/routine_repeat_days.dart';
import 'package:mobile/utils/app_logger.dart';

extension RepeatTypeExtension on ItemFrequency {
  String get label {
    switch (this) {
      case ItemFrequency.daily:
        return 'Daily';
      case ItemFrequency.weekly:
        return 'Weekly';
      case ItemFrequency.monthly:
        return 'Monthly';
    }
  }
}

class RepeatSettingsResult {
  final ItemFrequency frequency;
  final int interval;
  final List<int> weeklyDays;
  final DateTime startDate;

  RepeatSettingsResult({
    required this.frequency,
    required this.interval,
    required this.weeklyDays,
    required this.startDate,
  });
}

class RepeatFullScreen extends StatefulWidget {
  final ItemFrequency initialFrequency;
  final int initialInterval;
  final List<int> initialWeeklyDays;
  final DateTime initialStartDate;

  const RepeatFullScreen({
    super.key,
    required this.initialFrequency,
    required this.initialInterval,
    required this.initialStartDate,
    required this.initialWeeklyDays,
  });

  @override
  State<RepeatFullScreen> createState() => _RepeatFullScreenState();
}

class _RepeatFullScreenState extends State<RepeatFullScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ItemFrequency selectedFrequency;
  late int interval;
  late Set<int> selectedDays;
  late DateTime startDate;

  final logger = AppLogger.tag("RepeatFullScreen");

  @override
  void initState() {
    super.initState();
    selectedFrequency = widget.initialFrequency;
    interval = widget.initialInterval;
    selectedDays = widget.initialWeeklyDays.toSet();
    startDate = widget.initialStartDate;

    _tabController = TabController(
      length: ItemFrequency.values.length,
      vsync: this,
      initialIndex: ItemFrequency.values.indexOf(selectedFrequency),
    );
    _tabController.animation?.addListener(() {
      final int animatedIndex = _tabController.animation!.value.round();

      if (_tabController.indexIsChanging) {
        // For tab taps, only update when change completes
        if (selectedFrequency != ItemFrequency.values[_tabController.index]) {
          setState(
            () =>
                selectedFrequency = ItemFrequency.values[_tabController.index],
          );
        }
      } else {
        // For swipes, update as soon as index rounds to another tab
        if (selectedFrequency != ItemFrequency.values[animatedIndex]) {
          setState(
            () => selectedFrequency = ItemFrequency.values[animatedIndex],
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onApply() {
    Navigator.pop(
      context,
      RepeatSettingsResult(
        startDate: startDate,
        frequency: selectedFrequency,
        interval: interval,
        weeklyDays: selectedDays.toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(context),
            _buildTabBar(context),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDailyTab(),
                  _buildWeeklyTab(),
                  _buildMonthlyTab(),
                ],
              ),
            ),
            Center(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final newDate = await showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: startDate,
                    lastDate: DateTime.now().add(const Duration(days: 730)),
                  );
                  if (newDate != null) {
                    setState(() {
                      startDate = newDate;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(
                  'Start: ${DateFormat('MMM d, y').format(startDate)}',
                  style: const TextStyle(fontSize: 14),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: _onApply,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply Repeat Settings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: .3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: colorScheme.onSurface,
            ),
          ),
          Expanded(
            child: Text(
              'Repeat Settings',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: TabBar(
        controller: _tabController,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        indicatorColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        padding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: EdgeInsets.zero,
        isScrollable: true,
        tabAlignment: TabAlignment.center,
        tabs: List.generate(ItemFrequency.values.length, (index) {
          final type = ItemFrequency.values[index];
          final isSelected = selectedFrequency == type;
          return Tab(
            child: Container(
              width: 110,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                type.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDailyTab() {
    final intervals = [2, 3, 4, 5, 6];
    final selectedIndex = intervals.indexOf(interval);
    logger.debug("initial interval $interval");
    logger.debug("selected index $selectedIndex");
    return RepeatWheeltabSection(
      title: 'Repeat Frequency',
      intervals: intervals,
      startDate: startDate,
      onStartDateChanged: (value) => setState(() => startDate = value),
      selectedIndex: intervals.indexOf(interval),
      labelBuilder: (val) => 'Every $val days',
      onChanged: (i) => setState(() => interval = intervals[i]),
      height: 300,
    );
  }

  Widget _buildWeeklyTab() {
    final intervals = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Select Days',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: RoutineRepeatDays(
              selectedDays: selectedDays,
              onSelectionChanged: (days) => setState(() {
                selectedDays = days;
              }),
            ),
          ),
          const SizedBox(height: 24),
          RepeatWheeltabSection(
            title: 'Repeat Frequency',
            intervals: intervals,
            selectedIndex: intervals.indexOf(interval),
            labelBuilder: (val) => val == 1 ? 'Every week' : 'Every $val weeks',
            onStartDateChanged: (newDate) {
              setState(() {
                startDate = newDate;
              });
            },
            startDate: startDate,
            onChanged: (i) => setState(() => interval = intervals[i]),
            height: 200,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMonthlyTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_month, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Monthly Repeat',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text('Coming soon...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
