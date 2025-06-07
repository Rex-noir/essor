import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/daily_items/data/providers/habit_provider.dart';
import 'package:mobile/features/daily_items/data/providers/routine_local_provider.dart';
import 'package:mobile/features/daily_items/data/providers/task_local_proivder.dart';
import 'package:mobile/features/daily_items/data/repositories/habit_repository_impl.dart';
import 'package:mobile/features/daily_items/data/repositories/routine_repository_impl.dart';
import 'package:mobile/features/daily_items/data/repositories/task_repository_impl.dart';
import 'package:mobile/features/daily_items/domain/usecases/get_habits_for_date_usecase.dart';
import 'package:mobile/features/daily_items/domain/usecases/get_routines_for_date_usecase.dart';
import 'package:mobile/features/daily_items/domain/usecases/get_tasks_for_date_usecase.dart';
import 'package:mobile/features/daily_items/presentation/bloc/daily_list_bloc.dart';
import 'package:mobile/features/daily_items/presentation/screens/daily_list_screen.dart';
import 'package:mobile/features/home/presentation/widgets/home_greeting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  int activeIndex = 0;

  late final DailyListBloc _DailyListBloc;

  // Cache the tab views to prevent rebuilding
  late final List<Widget> _tabViews;
  bool _tabViewsInitialized = false;

  @override
  bool get wantKeepAlive => true; // Keep state alive

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    _tabController.animation!.addListener(() {
      if (_tabController.indexIsChanging) {
        if (activeIndex != _tabController.index) {
          activeIndex = _tabController.index;
        }
      } else {
        final int temp = _tabController.animation!.value.round();
        if (activeIndex != temp) {
          activeIndex = temp;
          _tabController.index = activeIndex;
        }
      }
    });

    _DailyListBloc = DailyListBloc(
      GetHabitsForDateUsecase(HabitRepositoryImpl(HabitLocalProvider())),
      GetRoutinesForDateUsecase(RoutineRepositoryImpl(RoutineLocalProvider())),
      GetTasksForDateUsecase(TaskRepositoryImpl(TaskLocalProivder())),
    )..add(DailyListInitialize());
  }

  // Initialize tab views only once
  void _initializeTabViews() {
    if (!_tabViewsInitialized) {
      _tabViews = [
        BlocProvider.value(
          value: _DailyListBloc,
          child: const DailyListScreen(),
        ),
        const _ExploreTab(), // Separate widget to avoid rebuilds
      ];
      _tabViewsInitialized = true;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _DailyListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    _initializeTabViews();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Header section - separate widget to prevent rebuilds
        _HeaderSection(tabController: _tabController, colorScheme: colorScheme),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            // Keep pages alive to maintain state
            children: _tabViews
                .map((child) => KeepAliveWrapper(child: child))
                .toList(),
          ),
        ),
      ],
    );
  }
}

// Separate header widget to prevent unnecessary rebuilds
class _HeaderSection extends StatelessWidget {
  final TabController tabController;
  final ColorScheme colorScheme;

  const _HeaderSection({
    required this.tabController,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeGreeting(
            username: 'Martiner',
            subtext: 'The Prok to the crok of the world.',
          ),
          const SizedBox(height: 24),
          Container(
            height: 56,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: tabController,
              indicator: const BoxDecoration(),
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              labelPadding: EdgeInsets.zero,
              tabs: [
                _CustomTab(
                  index: 0,
                  label: 'List',
                  colorScheme: colorScheme,
                  controller: tabController,
                  icon: Icons.calendar_today,
                ),
                _CustomTab(
                  index: 1,
                  controller: tabController,
                  label: 'Explore',
                  colorScheme: colorScheme,
                  icon: Icons.explore,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Optimized tab widget
class _CustomTab extends StatelessWidget {
  final int index;
  final String label;
  final TabController controller;
  final ColorScheme colorScheme;
  final IconData? icon;

  const _CustomTab({
    required this.index,
    required this.label,
    required this.controller,
    required this.colorScheme,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final isSelected = controller.index == index;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer.withOpacity(0.8)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? null
                : Border.all(
                    color: colorScheme.outline.withOpacity(0.3),
                    width: 1,
                  ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              if (icon != null) const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Separate explore widget to avoid rebuilds
class _ExploreTab extends StatelessWidget {
  const _ExploreTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Explore Content'));
  }
}

// Wrapper to keep tab contents alive
class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
