// Updated ListItemsPage - Non-grid minimalist list version
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

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

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

    _fadeController.forward();
  }

  @override
  void didUpdateWidget(ListItemsPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _refreshController.forward();
      } else {
        _refreshController.reverse();
      }
    }

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

  Widget _buildItemsList() {
    return CustomScrollView(
      key: PageStorageKey('tab_${widget.day}'),
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return _AnimatedListItem(
                index: index,
                animation: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildListItem(widget.items[index]),
                ),
              );
            }, childCount: widget.items.length),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
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
    final staggeredAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(
          (index * 0.1).clamp(0.0, 0.8),
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
            child: this.child,
          ),
        );
      },
    );
  }
}
