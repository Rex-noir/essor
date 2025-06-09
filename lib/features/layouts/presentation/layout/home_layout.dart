import 'package:flutter/material.dart';
import 'package:mobile/features/home/presentation/screens/home_screen.dart';
import 'package:mobile/features/layouts/presentation/widgets/home_add_action_card.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final ValueNotifier<bool> _isSheetOpen = ValueNotifier(false);
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _isSheetOpen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: [HomeScreen()]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _isSheetOpen,
        builder: (context, isOpen, _) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.only(bottom: 16),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 64,
                  margin: const EdgeInsets.symmetric(horizontal: 80),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: .95,
                    ),
                    borderRadius: BorderRadius.circular(64),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withValues(alpha: .1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(
                        icon: Icons.home_filled,
                        index: 0,
                        colorScheme: colorScheme,
                      ),
                      const SizedBox(width: 56),
                      _buildNavItem(
                        icon: Icons.person_2_sharp,
                        index: 3,
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                ),

                Positioned(
                  child: GestureDetector(
                    onTap: () {
                      if (_isSheetOpen.value) {
                        Navigator.of(context).pop();
                        _isSheetOpen.value = false;
                      } else {
                        _isSheetOpen.value = true;

                        showDialog(
                          context: context,
                          useSafeArea: true,
                          builder: (context) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {},
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 140,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        HomeAddActionCard(
                                          title: "New Habit",
                                          subtitle: "You can do it!",
                                          icon: Icons.add,
                                          backgroundColor: Colors.blue.shade50,
                                          onTap: () {
                                            // Todo
                                          },
                                        ),
                                        HomeAddActionCard(
                                          title: "New Routine",
                                          subtitle: "Stay consistent!",
                                          icon: Icons.add,
                                          backgroundColor: Colors.green.shade50,
                                          onTap: () {
                                            // Todo
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 16,
                                    left:
                                        MediaQuery.of(context).size.width / 2 -
                                        36,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _rotationController
                                            .reverse(); // Reverse animation
                                        _isSheetOpen.value = false;
                                      },
                                      child: Container(
                                        height: 72,
                                        width: 72,
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.35),
                                              blurRadius: 20,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: AnimatedBuilder(
                                          animation: _rotationController,
                                          builder: (context, child) {
                                            return Transform.rotate(
                                              angle:
                                                  _rotationController.value *
                                                  0.7854,
                                              child: child,
                                            );
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 36,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ).whenComplete(() {
                          _isSheetOpen.value = false;
                        });
                      }
                    },
                    child: Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: .35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: AnimatedBuilder(
                        animation: _rotationController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle:
                                _rotationController.value *
                                0.7854, // 45 degrees in radians
                            child: child,
                          );
                        },
                        child: AnimatedBuilder(
                          animation: _rotationController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle:
                                  _rotationController.value *
                                  0.7854, // 45 degrees
                              child: child,
                            );
                          },
                          child: Icon(
                            Icons.add,
                            size: 36,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
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

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required ColorScheme colorScheme,
  }) {
    final isSelected = _selectedIndex == index;

    return IconButton(
      icon: Icon(
        icon,
        size: isSelected ? 28 : 24,
        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}
