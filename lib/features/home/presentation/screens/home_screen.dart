import 'package:flutter/material.dart';
import 'package:mobile/features/home/presentation/widgets/home_greeting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              const HomeGreeting(
                username: 'Martiner',
                subtext: 'The Prok to the crok of the world.',
              ),
              Container(
                height: 64,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: const BoxDecoration(),
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  labelPadding: EdgeInsets.zero,
                  tabs: [
                    _buildTab(
                      index: 0,
                      label: 'List',
                      colorScheme: colorScheme,
                      controller: _tabController,
                      icon: Icons.calendar_today,
                    ),
                    _buildTab(
                      index: 1,
                      controller: _tabController,
                      label: 'Explore',
                      colorScheme: colorScheme,
                      icon: Icons.explore,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              Center(child: Text('Hi Content')),
              Center(child: Text('Explore Content')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab({
    required int index,
    required String label,
    required TabController controller,
    required ColorScheme colorScheme,
    IconData? icon,
  }) {
    final isSelected = controller.index == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
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
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          if (icon != null) const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
