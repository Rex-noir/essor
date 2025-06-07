import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/utils/app_logger.dart';
import 'package:mobile/features/habit_list/presentation/bloc/habit_list_bloc.dart';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({super.key});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final logger = AppLogger.tag("HabitListScreen");

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateTabController(int newLength, int selectedIndex) {
    final oldController = _tabController;
    _tabController = TabController(
      length: newLength,
      vsync: this,
      initialIndex: selectedIndex,
    );

    int activeIndex = selectedIndex;

    _tabController.animation!.addListener(() {
      // this will catch a tab change by tapping on the tab bar
      if (_tabController.indexIsChanging) {
        if (activeIndex != _tabController.index) {
          context.read<HabitListBloc>().add(
            HabitListDateChanged(_tabController.index),
          );
        }
        // this will catch a tab change by swipe
      } else {
        final int temp = _tabController.animation!.value.round();
        if (activeIndex != temp) {
          activeIndex = temp;
          context.read<HabitListBloc>().add(HabitListDateChanged(activeIndex));
        }
      }
    });
    oldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HabitListBloc, HabitListState>(
      listener: (context, state) {
        if (state is HabitListLoaded) {
          _updateTabController(state.days.length, state.selectedIndex);
        }
      },
      builder: (context, state) {
        if (state is! HabitListLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final days = state.days;

        return Column(
          children: [
            TabBar(
              controller: _tabController,
              isScrollable: true,
              key: UniqueKey(),
              tabAlignment: TabAlignment.center,
              indicatorPadding: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              labelPadding: const EdgeInsets.all(4),
              tabs: days.map((day) {
                final dayName = DateFormat('EEE').format(day);
                final index = days.indexOf(day);
                final isSelected = state.selectedIndex == index;

                return Container(
                  height: 90,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: isSelected
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          )
                        : Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.2),
                            width: 2,
                          ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${day.day}",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dayName,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withValues(alpha: .7),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: days.map((day) {
                  return Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: Center(
                      child: Text(
                        "Habits for ${day.toLocal()}",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
