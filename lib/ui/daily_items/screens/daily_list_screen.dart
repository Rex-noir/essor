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
  late PageController _pageController;
  int _currentTabIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isAnimatingFromTab = false;

  final logger = AppLogger.tag("DailyListScreen");
  bool _isUpdatingControllers = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: DailyListBloc.initialDaysEachSide * 2 + 1,
      vsync: this,
    );
    _pageController = PageController(
      initialPage: DailyListBloc.initialDaysEachSide,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();

    // Add listeners
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging &&
        !_isAnimatingFromTab &&
        _pageController.hasClients) {
      _isAnimatingFromTab = true;
      _pageController
          .animateToPage(
            _tabController.index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          )
          .then((_) {
            _isAnimatingFromTab = false;
          });
    }
  }

  void _handlePageChanged(int index) {
    if (_isUpdatingControllers) return;

    logger.debug("Page changed $index");
    if (!_isAnimatingFromTab) {
      setState(() {
        _currentTabIndex = index;
      });
      _tabController.animateTo(index);
      context.read<DailyListBloc>().add(DailyListDateChanged(index));
    }
  }

  void _updateControllers(int newLength, int selectedIndex) {
    _isUpdatingControllers = true;

    if (_tabController.length != newLength) {
      _tabController.removeListener(_handleTabSelection);
      _tabController.dispose();

      logger.debug("Controllers updated with new length: $newLength");

      _tabController = TabController(
        length: newLength,
        vsync: this,
        initialIndex: selectedIndex,
      );

      _pageController.dispose();
      _pageController = PageController(initialPage: selectedIndex);

      setState(() {
        _currentTabIndex = selectedIndex;
      });

      _tabController.addListener(_handleTabSelection);
    } else if (_currentTabIndex != selectedIndex) {
      setState(() {
        _currentTabIndex = selectedIndex;
      });
      _tabController.animateTo(selectedIndex);
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          selectedIndex,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    }

    Future.delayed(const Duration(milliseconds: 250), () {
      _isUpdatingControllers = false;
    });
  }

  void _onTabTap(int index) {
    _isAnimatingFromTab = true;
    setState(() {
      _currentTabIndex = index;
    });

    // Immediately update tab controller without animation
    _tabController.index = index;

    // Animate page controller if it's attached
    if (_pageController.hasClients) {
      _pageController
          .animateToPage(
            index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          )
          .then((_) {
            _isAnimatingFromTab = false;
          });
    } else {
      _isAnimatingFromTab = false;
    }

    // Update bloc
    context.read<DailyListBloc>().add(DailyListDateChanged(index));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocConsumer<DailyListBloc, DailyListState>(
      listener: (context, state) {
        if (state is DailyListLoaded) {
          _updateControllers(state.days.length, state.selectedIndex);
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
                      onTap: _onTabTap,
                    ),
                  Expanded(
                    child: () {
                      if (state is DailyListLoading ||
                          state is DailyListInitial) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is DailyListError) {
                        return Center(child: Text(state.message));
                      } else if (state is DailyListLoaded) {
                        return PageView.builder(
                          controller: _pageController,
                          onPageChanged: _handlePageChanged,
                          itemCount: state.days.length,
                          itemBuilder: (context, index) {
                            final day = state.days[index];
                            final dayKey = day.toIso8601String();
                            final isCurrent = index == _currentTabIndex;

                            return ListItemsPage(
                              day: dayKey,
                              key: ValueKey(day),
                              items: isCurrent ? state.items : [],
                              isLoading: state.isLoading,
                              onRefresh: () {
                                // refresh logic
                              },
                            );
                          },
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
