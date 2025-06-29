import 'package:flutter/material.dart';

class DailyListEmptyWidget extends StatelessWidget {
  const DailyListEmptyWidget({
    super.key,
    required Animation<double> fadeAnimation,
    required this.theme,
    required this.colorScheme,
  }) : _fadeAnimation = fadeAnimation;

  final Animation<double> _fadeAnimation;
  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
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
                      Icons.grid_view_outlined,
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
}
