import 'package:flutter/material.dart';
import 'package:mobile/ui/daily_items/bloc/daily_list_bloc.dart';
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
                      ? _buildEmptyState(theme, colorScheme)
                      : _buildItemsList(),
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

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_fadeAnimation),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Icon(
                      Icons.add_box_outlined,
                      size: 80,
                      color: colorScheme.onSurface.withValues(alpha: .4),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                "No items for this day yet!",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Add some habits or routines to get started.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return ListView.separated(
      key: PageStorageKey('tab_${widget.day}'),
      padding: const EdgeInsets.only(bottom: 80),
      physics: const AlwaysScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return _AnimatedListItem(
          index: index,
          animation: _fadeAnimation,
          child: _buildListItem(widget.items[index]),
        );
      },
      itemCount: widget.items.length,
    );
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

class _AnimatedListItem extends StatelessWidget {
  final int index;
  final Animation<double> animation;
  final Widget child;

  const _AnimatedListItem({
    required this.index,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Stagger the animation based on the index
    final staggeredAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(
          (index * 0.1).clamp(0.0, 1.0), // Stagger by 100ms per item
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
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(staggeredAnimation),
            child: Transform.scale(
              scale: 0.8 + (0.2 * staggeredAnimation.value),
              child: this.child,
            ),
          ),
        );
      },
    );
  }
}
