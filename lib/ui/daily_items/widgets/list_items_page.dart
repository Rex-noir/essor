import 'package:flutter/material.dart';
import 'package:mobile/ui/daily_items/bloc/daily_list_bloc.dart';
import 'package:mobile/ui/daily_items/widgets/habit_list_item.dart';
import 'package:mobile/ui/daily_items/widgets/routine_list_item.dart';

class ListItemsPage extends StatefulWidget {
  final String day;
  final List<DailyItem> items;
  final bool isLoading;
  final ScrollController? scrollController;
  final VoidCallback onRefresh;

  const ListItemsPage({
    required this.day,
    required this.items,
    required this.isLoading,
    required this.onRefresh,
    this.scrollController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ListItemsPageState();
}

class _ListItemsPageState extends State<ListItemsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Get theme and color scheme for consistent styling
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
        color: colorScheme.surface, // Use colorScheme for consistency
        child: widget.isLoading
            ? const Center(child: CircularProgressIndicator())
            : widget
                  .items
                  .isEmpty // Check if items list is empty
            ? Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.add_box_outlined, // A suitable icon for empty state
                      size: 80,
                      color: colorScheme.onSurface.withValues(alpha: .4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No items for this day yet!",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Add some habits or routines to get started.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.separated(
                key: PageStorageKey('tab_${widget.day}'),
                controller: widget.scrollController,
                padding: const EdgeInsets.only(bottom: 80),
                physics: const AlwaysScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = widget.items[index];

                  if (item is HabitItem) {
                    return HabitListItem(habit: item.habit);
                  } else if (item is RoutineItem) {
                    return RoutineListItem(routine: item.routine);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
                itemCount: widget.items.length,
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
