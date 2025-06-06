import 'package:flutter/material.dart';

class HomeGreeting extends StatelessWidget {
  final String username;
  final String subtext;
  const HomeGreeting({
    required this.username,
    required this.subtext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi,$username!", style: textTheme.titleLarge),
            Text(subtext, style: textTheme.bodySmall),
          ],
        ),
        const Spacer(),
        IconButton.outlined(
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            // Todo
          },
          icon: Icon(Icons.notifications),
        ),
      ],
    );
  }
}
