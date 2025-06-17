import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile/ui/daily_items/bloc/daily_list_bloc.dart';
import 'package:mobile/ui/daily_items/widgets/list_items_page.dart';
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

  static const minChildSize = 0.65;
  static const maxChildSize = 1.0;

  final Map<String, ScrollController> _scrollControllers = {};

  // Add DraggableScrollableController for the expandable content
  late DraggableScrollableController _dragController;
  double _currentExtent = 0.6; // Initial height (60% of screen)
  bool _isExpanded = false;

  final logger = AppLogger.tag("DailyListScreen");

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();

    // Initialize the drag controller
    _dragController = DraggableScrollableController();
    _dragController.addListener(_onDragUpdate);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    _dragController.removeListener(_onDragUpdate);
    _dragController.dispose();

    for (var controller in _scrollControllers.values) {
      controller.dispose();
    }
    _scrollControllers.clear();
    super.dispose();
  }

  void _onDragUpdate() {
    setState(() {
      _currentExtent = _dragController.size;
      _isExpanded = _currentExtent > 0.8;
    });
  }

  ScrollController _getScrollController(String dayKey) {
    if (!_scrollControllers.containsKey(dayKey)) {
      _scrollControllers[dayKey] = ScrollController();
    }
    return _scrollControllers[dayKey]!;
  }

  void _toggleExpansion() {
    if (_isExpanded) {
      _dragController.animateTo(
        0.65,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _dragController.animateTo(
        1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateTabController(int newLength, int selectedIndex) {
    final oldController = _tabController;
    _tabController = TabController(
      length: newLength,
      vsync: this,
      initialIndex: selectedIndex,
    );

    _currentTabIndex = selectedIndex;

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
        context.read<DailyListBloc>().add(
          DailyListDateChanged(_tabController.index),
        );
      }
    });

    _tabController.animation!.addListener(() {
      if (!_tabController.indexIsChanging) {
        final int temp = _tabController.animation!.value.round();
        if (_currentTabIndex != temp) {
          setState(() {
            _currentTabIndex = temp;
          });
          context.read<DailyListBloc>().add(DailyListDateChanged(temp));
        }
      }
    });

    oldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocConsumer<DailyListBloc, DailyListState>(
      listener: (context, state) {
        if (state is HabitListLoaded) {
          _updateTabController(state.days.length, state.selectedIndex);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            // Background with header and tabs
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.surface,
                    colorScheme.surface.withValues(alpha: 0.95),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  AnimatedOpacity(
                    opacity: _currentExtent < 0.9 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: _buildHeader(context, state),
                  ),
                  // Tab section
                  AnimatedOpacity(
                    opacity: _currentExtent < 0.9 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: _buildTabSection(context, state),
                  ),
                  // Spacer to push content down
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),

            // Draggable content section
            DraggableScrollableSheet(
              controller: _dragController,
              initialChildSize: minChildSize,
              minChildSize: minChildSize,
              maxChildSize: maxChildSize,
              snap: true,
              snapSizes: const [minChildSize, maxChildSize],
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_isExpanded ? 0 : 24),
                      topRight: Radius.circular(_isExpanded ? 0 : 24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Drag handle section
                      _buildDragHandle(context, state),

                      // Content section
                      Expanded(
                        child: state is! HabitListLoaded
                            ? const Center(child: CircularProgressIndicator())
                            : TabBarView(
                                controller: _tabController,
                                children: state.days.map((day) {
                                  final dayKey = day.toIso8601String();

                                  return ListItemsPage(
                                    day: dayKey,
                                    key: ValueKey(day),
                                    items: state.items,
                                    isLoading: state.isLoading,
                                    scrollController: _getScrollController(
                                      dayKey,
                                    ), // Use separate controller
                                    // Pass the scroll controller
                                    onRefresh: () {
                                      logger.info("Refresh called");
                                    },
                                  );
                                }).toList(),
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDragHandle(BuildContext context, DailyListState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          // Drag indicator
          if (!_isExpanded)
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: .3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

          // Expanded header
          if (_isExpanded) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _toggleExpansion,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Daily Items",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (state is HabitListLoaded)
                          Text(
                            DateFormat.yMMMMEEEEd().format(
                              state.days[_currentTabIndex],
                            ),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DailyListState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Daily Items",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          if (state is HabitListLoaded)
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                DateFormat.yMMMMEEEEd().format(state.days[_currentTabIndex]),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            )
          else
            Text(
              DateFormat.yMMMMEEEEd().format(DateTime.now()),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabSection(BuildContext context, DailyListState state) {
    if (state is! HabitListLoaded) {
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

    final days = state.days;
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
