import 'package:flutter/material.dart';
import 'package:mobile/ui/daily_items/bloc/daily_list_bloc.dart';
import 'package:mobile/ui/daily_items/widgets/daily_list_empty_widget.dart';

import 'package:mobile/ui/daily_items/widgets/habit_list_item.dart';
import 'package:mobile/ui/daily_items/widgets/routine_list_item.dart';

class ListItemsPage extends StatefulWidget {
  final String day;
  final List<DailyItem> items;
  final VoidCallback onRefresh;
  final bool isLoading;

  const ListItemsPage({
    required this.day,
    required this.items,
    required this.onRefresh,
    required this.isLoading,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ListItemsPageState();
}

class _ListItemsPageState extends State<ListItemsPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _refreshController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _refreshAnimation;

  @override
  void initState() {
    super.initState();

    // Controller for fade-in animation of items
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Controller for refresh loading animation
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );

    _refreshAnimation = CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    );

    // Start initial animation
    _fadeController.forward();
  }

  @override
  void didUpdateWidget(ListItemsPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Animate when loading state changes
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _refreshController.forward();
      } else {
        _refreshController.reverse();
      }
    }

    // Restart animation when items change
    if (widget.items.length != oldWidget.items.length) {
      _fadeController.reset();
      _fadeController.forward();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  // Calculate responsive grid columns based on screen width
  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth >= 1200) {
      return 4; // Desktop
    } else if (screenWidth >= 800) {
      return 3; // Tablet landscape
    } else if (screenWidth >= 600) {
      return 2; // Tablet portrait
    } else {
      return 2; // Mobile - now shows 2 columns instead of 1
    }
  }

  // Calculate responsive item spacing
  double _calculateSpacing(double screenWidth) {
    if (screenWidth >= 800) {
      return 16.0; // Larger screens
    } else if (screenWidth >= 400) {
      return 12.0; // Medium mobile screens
    } else {
      return 1; // Smaller mobile screens
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh();
      },
      child: AnimatedBuilder(
        animation: _refreshAnimation,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
            color: colorScheme.surface,
            child: Stack(
              children: [
                // Main content
                AnimatedOpacity(
                  opacity: widget.isLoading ? 0.7 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: widget.items.isEmpty
                      ? DailyListEmptyWidget(
                          fadeAnimation: _fadeAnimation,
                          theme: theme,
                          colorScheme: colorScheme,
                        )
                      : _buildItemsGrid(),
                ),

                // Loading overlay
                if (widget.isLoading)
                  Positioned.fill(
                    child: FadeTransition(
                      opacity: _refreshAnimation,
                      child: Container(
                        color: colorScheme.surface.withValues(alpha: 0.3),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final crossAxisCount = _calculateCrossAxisCount(screenWidth);
        final spacing = _calculateSpacing(screenWidth);

        return CustomScrollView(
          key: PageStorageKey('tab_${widget.day}'),
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(bottom: 80),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: _calculateChildAspectRatio(crossAxisCount),
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return _AnimatedGridItem(
                    index: index,
                    animation: _fadeAnimation,
                    child: _buildListItem(widget.items[index]),
                  );
                }, childCount: widget.items.length),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100), // adjust height as needed
            ),
          ],
        );
      },
    );
  }

  // Calculate aspect ratio based on number of columns
  double _calculateChildAspectRatio(int crossAxisCount) {
    switch (crossAxisCount) {
      case 2:
        return 0.75; // Taller items on mobile
      case 3:
        return 0.85; // More height on tablets
      case 4:
        return 0.95; // Slightly taller on desktop
      default:
        return 0.8;
    }
  }

  Widget _buildListItem(DailyItem item) {
    if (item is HabitItem) {
      return HabitListItem(habit: item.habit);
    } else if (item is RoutineItem) {
      return RoutineListItem(routine: item.routine);
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class _AnimatedGridItem extends StatelessWidget {
  final int index;
  final Animation<double> animation;
  final Widget child;

  const _AnimatedGridItem({
    required this.index,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Stagger the animation based on the index with a slightly different timing for grid
    final staggeredAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(
          (index * 0.05).clamp(0.0, 0.8), // Faster stagger for grid items
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: staggeredAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: staggeredAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(staggeredAnimation),
            child: Transform.scale(
              scale: 0.9 + (0.1 * staggeredAnimation.value),
              child: this.child,
            ),
          ),
        );
      },
    );
  }
}
