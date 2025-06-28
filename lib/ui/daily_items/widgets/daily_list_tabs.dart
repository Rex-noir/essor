import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/ui/daily_items/bloc/daily_list_bloc.dart';

class DailyListTabs extends StatelessWidget {
  const DailyListTabs({
    super.key,
    required TabController tabController,
    required int currentTabIndex,
    required this.context,
    required this.state,
    this.onTap,
  }) : _tabController = tabController,
       _currentTabIndex = currentTabIndex;

  final TabController _tabController;
  final int _currentTabIndex;
  final BuildContext context;
  final DailyListState state;
  final Function(int index)? onTap;

  @override
  Widget build(BuildContext context) {
    if (state is! DailyListLoaded) {
      return Container(
        height: 110,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: SizedBox(
            width: 70,
            height: 90,
            child: Card(
              elevation: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ),
      );
    }

    final days = (state as DailyListLoaded).days;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        key: ValueKey(days.map((e) => e.toIso8601String()).join(',')),
        tabAlignment: TabAlignment.center,
        indicatorPadding: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        dividerColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        onTap: onTap,
        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
        splashFactory: NoSplash.splashFactory,
        tabs: days.asMap().entries.map((entry) {
          final index = entry.key;
          final day = entry.value;
          final dayName = DateFormat('EEE').format(day);
          final isSelected = _currentTabIndex == index;
          final isToday = DateUtils.isSameDay(day, DateTime.now());

          return Container(
            height: 90,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: 0.8),
                      ],
                    )
                  : null,
              color: isSelected ? null : colorScheme.surface,
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : isToday
                    ? colorScheme.primary.withValues(alpha: .3)
                    : colorScheme.outline.withValues(alpha: 0.2),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                    fontWeight: isSelected || isToday
                        ? FontWeight.bold
                        : FontWeight.w500,
                  ),
                  child: Text("${day.day}"),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: theme.textTheme.labelSmall!.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary.withValues(alpha: 0.9)
                        : colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                  ),
                  child: Text(dayName),
                ),
                if (isToday)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.primary,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
