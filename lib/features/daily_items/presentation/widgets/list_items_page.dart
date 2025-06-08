import 'package:flutter/material.dart';
import 'package:mobile/features/daily_items/presentation/bloc/daily_list_bloc.dart';
import 'package:mobile/features/daily_items/presentation/widgets/habit_list_item.dart';
import 'package:mobile/features/daily_items/presentation/widgets/routine_list_item.dart';

class ListItemsPage extends StatefulWidget {
  final String day;
  final List<DailyItem> items;
  final bool isLoading;
  final VoidCallback onRefresh;

  const ListItemsPage({
    required this.day,
    required this.items,
    required this.isLoading,
    required this.onRefresh,
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

    return RefreshIndicator(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
        color: Theme.of(context).colorScheme.surface,
        child: widget.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                key: PageStorageKey('tab_${widget.day}'),
                padding: EdgeInsets.only(bottom: 80),
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
      onRefresh: () async {
        widget.onRefresh();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
