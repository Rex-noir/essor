import 'package:flutter/material.dart';
import 'package:mobile/features/home/presentation/screens/home_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _selectedIndex = 0;

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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Nav Bar Background
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
                  const SizedBox(width: 56), // space for center FAB
                  _buildNavItem(
                    icon: Icons.person_2_sharp,
                    index: 3,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),

            // Center Elevated Action Button
            Positioned(
              child: GestureDetector(
                onTap: () {
                  // custom center action
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
                  child: Icon(
                    Icons.add,
                    size: 36,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
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
