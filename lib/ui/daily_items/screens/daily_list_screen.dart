import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mobile/ui/daily_items/bloc/daily_list_bloc.dart';
import 'package:mobile/ui/daily_items/widgets/daily_list_tabs.dart';
import 'package:mobile/ui/daily_items/widgets/daily_list_header.dart';
import 'package:mobile/ui/daily_items/widgets/daily_lists_widget.dart';
import 'package:mobile/utils/app_logger.dart';

class DailyListScreen extends StatefulWidget {
  const DailyListScreen({super.key});

  @override
  State<DailyListScreen> createState() => _DailyListScreenState();
}

class _DailyListScreenState extends State<DailyListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final logger = AppLogger.tag("DailyListScreen");

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: DailyListBloc.initialDaysEachSide * 2 + 1,
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();

    // Initialize the drag controller
    _tabController.addListener(_handleTabSelection); // Add listener once
    _tabController.animation!.addListener(
      _handleTabAnimation,
    ); // Add listener once
  }

  @override
  void dispose() {
    // Remove listeners before disposing
    _tabController.removeListener(_handleTabSelection);
    _tabController.animation!.removeListener(_handleTabAnimation);
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
      context.read<DailyListBloc>().add(
        DailyListDateChanged(_tabController.index),
      );
    }
  }

  void _handleTabAnimation() {
    if (!_tabController.indexIsChanging) {
      final int temp = _tabController.animation!.value.round();
      if (_currentTabIndex != temp) {
        setState(() {
          _currentTabIndex = temp;
        });
        context.read<DailyListBloc>().add(DailyListDateChanged(temp));
      }
    }
  }

  void _updateTabController(int newLength, int selectedIndex) {
    if (_tabController.length != newLength) {
      // Dispose old listeners before re-creating
      _tabController.removeListener(_handleTabSelection);
      _tabController.animation!.removeListener(_handleTabAnimation);
      _tabController.dispose();

      logger.debug("Tab controler updated with new length: $newLength");

      _tabController = TabController(
        length: newLength,
        vsync: this,
        initialIndex: selectedIndex,
      );
      // Add listeners to the new controller
      _tabController.addListener(_handleTabSelection);
      _tabController.animation!.addListener(_handleTabAnimation);

      // Immediately update the current index as the controller is new
      _currentTabIndex = selectedIndex;
    } else if (_currentTabIndex != selectedIndex) {
      // If length is the same, just animate/jump to the new index
      // This avoids disposing/recreating the controller unnecessarily.
      _tabController.animateTo(
        selectedIndex,
        duration: const Duration(milliseconds: 300), // Optional animation
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocConsumer<DailyListBloc, DailyListState>(
      listener: (context, state) {
        if (state is DailyListLoaded) {
          _updateTabController(state.days.length, state.selectedIndex);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.surface,
                    colorScheme.surface.withValues(alpha: .95),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DailyListHeader(
                    fadeAnimation: _fadeAnimation,
                    context: context,
                    state: state,
                  ),
                  if (state is DailyListLoaded)
                    DailyListTabs(
                      tabController: _tabController,
                      currentTabIndex: _currentTabIndex,
                      context: context,
                      state: state,
                    ),
                  Expanded(
                    child: () {
                      if (state is DailyListLoading ||
                          state is DailyListInitial) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is DailyListError) {
                        return Center(child: Text(state.message));
                      } else if (state is DailyListLoaded) {
                        return TabBarView(
                          controller: _tabController,
                          children: state.days.map((day) {
                            final dayKey = day.toIso8601String();
                            final isCurrent =
                                state.days.indexOf(day) == _currentTabIndex;

                            return ListItemsPage(
                              day: dayKey,
                              key: ValueKey(day),
                              items: isCurrent ? state.items : [],
                              isLoading: state.isLoading,
                              onRefresh: () {
                                // refresh logic
                              },
                            );
                          }).toList(),
                        );
                      } else {
                        return const SizedBox(); // fallback for unexpected state
                      }
                    }(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
