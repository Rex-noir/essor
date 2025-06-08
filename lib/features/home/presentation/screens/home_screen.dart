import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/daily_items/data/datasources/habit_local_datasource.dart';
import 'package:mobile/features/daily_items/data/datasources/routine_local_datasource.dart';
import 'package:mobile/features/daily_items/data/datasources/task_local_datasource.dart';
import 'package:mobile/features/daily_items/data/repositories/habit_repository_impl.dart';
import 'package:mobile/features/daily_items/data/repositories/routine_repository_impl.dart';
import 'package:mobile/features/daily_items/data/repositories/task_repository_impl.dart';
import 'package:mobile/features/daily_items/domain/usecases/get_habits_for_date_usecase.dart';
import 'package:mobile/features/daily_items/domain/usecases/get_routines_for_date_usecase.dart';
import 'package:mobile/features/daily_items/domain/usecases/get_tasks_for_date_usecase.dart';
import 'package:mobile/features/daily_items/presentation/bloc/daily_list_bloc.dart';
import 'package:mobile/features/daily_items/presentation/screens/daily_list_screen.dart';
import 'package:mobile/features/home/presentation/widgets/home_greeting.dart';

/// Main home screen with optimized tab management and dependency injection
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tabController;
  late final DailyListBloc _dailyListBloc;

  // Tab configuration
  static const int _initialTabIndex = 0;
  static const int _tabCount = 2;
  int activeIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeBloc();
    _tabAnimationListener();
  }

  void _initializeControllers() {
    _tabController = TabController(
      initialIndex: _initialTabIndex,
      length: _tabCount,
      vsync: this,
    );
  }

  void _initializeBloc() {
    _dailyListBloc = DailyListBloc(
      GetHabitsForDateUsecase(HabitRepositoryImpl(HabitLocalDataSource())),
      GetRoutinesForDateUsecase(
        RoutineRepositoryImpl(RoutineLocalDataSource()),
      ),
      GetTasksForDateUsecase(TaskRepositoryImpl(TaskLocalDataSource())),
    )..add(DailyListInitialize());
  }

  void _tabAnimationListener() {
    _tabController.animation!.addListener(() {
      if (_tabController.indexIsChanging) {
        // When tapped on a tab
        if (activeIndex != _tabController.index) {
          activeIndex = _tabController.index;
        }
      } else {
        // When swiping between tabs
        final int temp = _tabController.animation!.value.round();
        if (activeIndex != temp) {
          activeIndex = temp;
          _tabController.index = activeIndex; // Snaps immediately
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dailyListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Column(
      children: [
        _HomeHeader(tabController: _tabController),
        Expanded(
          child: _TabContent(
            tabController: _tabController,
            dailyListBloc: _dailyListBloc,
          ),
        ),
      ],
    );
  }
}

/// Separate header component for better modularity
class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: .05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeGreeting(
            username: 'Martiner',
            subtext: 'The Prok to the crok of the world.',
          ),
          const SizedBox(height: 24),
          _CustomTabBar(controller: tabController),
        ],
      ),
    );
  }
}

/// Enhanced tab bar with improved animations and accessibility
class _CustomTabBar extends StatelessWidget {
  const _CustomTabBar({required this.controller});

  final TabController controller;

  static const List<_TabConfig> _tabs = [
    _TabConfig(label: 'Today', icon: Icons.today_outlined),
    _TabConfig(label: 'Explore', icon: Icons.explore_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 60,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: .12),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelPadding: EdgeInsets.zero,
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        tabs: _tabs.asMap().entries.map((entry) {
          return _AnimatedTab(
            index: entry.key,
            config: entry.value,
            controller: controller,
          );
        }).toList(),
      ),
    );
  }
}

/// Configuration class for tab data
class _TabConfig {
  const _TabConfig({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

/// Individual animated tab with smooth transitions
class _AnimatedTab extends StatelessWidget {
  const _AnimatedTab({
    required this.index,
    required this.config,
    required this.controller,
  });

  final int index;
  final _TabConfig config;
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final theme = Theme.of(context);
        final isSelected = controller.index == index;

        return Tab(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? _getFilledIcon() : config.icon,
                    size: 20,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  child: Text(config.label),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getFilledIcon() {
    switch (config.icon) {
      case Icons.today_outlined:
        return Icons.today;
      case Icons.explore_outlined:
        return Icons.explore;
      default:
        return config.icon;
    }
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({required this.tabController, required this.dailyListBloc});

  final TabController tabController;
  final DailyListBloc dailyListBloc;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        _KeepAliveTab(
          child: BlocProvider.value(
            value: dailyListBloc,
            child: const DailyListScreen(),
          ),
        ),
        const _KeepAliveTab(child: _ExploreTab()),
      ],
    );
  }
}

/// Enhanced explore tab with placeholder content
class _ExploreTab extends StatelessWidget {
  const _ExploreTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore_outlined,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'Explore',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Discover new habits and routines',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Optimized keep-alive wrapper with better performance
class _KeepAliveTab extends StatefulWidget {
  const _KeepAliveTab({required this.child});

  final Widget child;

  @override
  State<_KeepAliveTab> createState() => _KeepAliveTabState();
}

class _KeepAliveTabState extends State<_KeepAliveTab>
    with AutomaticKeepAliveClientMixin<_KeepAliveTab> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
