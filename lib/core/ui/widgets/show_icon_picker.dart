import 'package:flutter/material.dart';

Future<int?> showIconPicker(
  BuildContext context,
  Map<String, List<IconData>> categorizedIcons,
) {
  final categories = categorizedIcons.keys.toList();

  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => DefaultTabController(
      length: categories.length,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            isScrollable: true,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
            tabs: [for (final category in categories) Tab(text: category)],
          ),
          Container(
            height: 300, // Adjust as needed
            padding: const EdgeInsets.all(16),
            child: TabBarView(
              children: [
                for (final category in categories)
                  GridView.builder(
                    itemCount: categorizedIcons[category]!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                    itemBuilder: (context, index) {
                      final icon = categorizedIcons[category]![index];
                      final flatIndex =
                          categorizedIcons.entries
                              .takeWhile((e) => e.key != category)
                              .fold(0, (total, e) => total + e.value.length) +
                          index;

                      return InkWell(
                        onTap: () {
                          Navigator.pop(
                            context,
                            flatIndex,
                          ); // Return flat index
                        },
                        borderRadius: BorderRadius.circular(999),
                        splashColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.2),
                        child: Ink(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                          ),
                          child: Center(child: Icon(icon, size: 28)),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
