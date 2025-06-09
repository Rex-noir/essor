import 'package:flutter/material.dart';
import 'package:mobile/ui/new_routine/widgets/route_repeat_choice_chip.dart';

class NewRoutineScreen extends StatelessWidget {
  const NewRoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("New Routine"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close),
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: TextField(
                  decoration: InputDecoration(hintText: 'Routine Title'),
                  textAlign: TextAlign.center,
                  autofocus: true,
                ),
              ),

              // Repeat
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.repeat),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Repeat", style: textTheme.labelMedium),
                          Text(
                            "Daily",
                            style: textTheme.labelSmall?.copyWith(
                              color: textTheme.labelSmall?.color?.withValues(
                                alpha: 0.6,
                              ), // 60% opacity
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              runAlignment: WrapAlignment.start,
                              children: [
                                RoutineRepeatChoiceChip(
                                  label: "Mo",
                                  selected: true,
                                ),
                                RoutineRepeatChoiceChip(
                                  label: "Tu",
                                  selected: false,
                                ),
                                RoutineRepeatChoiceChip(
                                  label: "We",
                                  selected: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
