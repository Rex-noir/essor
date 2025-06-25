import 'package:flutter/material.dart';
import 'package:mobile/core/config/app_config.dart';
import 'package:mobile/core/config/app_icons.dart';
import 'package:mobile/core/extensions/date_extensions.dart';
import 'package:mobile/core/ui/widgets/show_icon_picker.dart';
import 'package:mobile/domain/models/task_entry_model.dart';
import 'package:mobile/domain/models/task_model.dart';
import 'package:mobile/domain/models/task_with_entry_model.dart';
import 'package:mobile/ui/view_routine/widgets/routine_task_duration.dart';
import 'package:mobile/ui/view_routine/widgets/routine_task_title.dart';
import 'package:uuid/v4.dart';

class NewRoutineTaskScreen extends StatefulWidget {
  final String routineId;
  const NewRoutineTaskScreen({required this.routineId, super.key});

  @override
  State<NewRoutineTaskScreen> createState() => _NewRoutineTaskScreenState();
}

class _NewRoutineTaskScreenState extends State<NewRoutineTaskScreen> {
  late TextEditingController _titleController;
  late int _iconIndex;
  late Duration duration;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _iconIndex = AppConfig.taskIconIndex;
    duration = Duration(minutes: 1);
  }

  _onSave() {
    final TaskModel model = TaskModel(
      duration: duration,
      id: UuidV4().generate(),
      title: _titleController.text,
      iconIndex: _iconIndex,
      importance: 1,
      routineId: widget.routineId,
    );

    final TaskEntryModel entry = TaskEntryModel(
      id: UuidV4().generate(),
      taskId: model.id,
      completed: false,
      entryDate: DateTime.now().dateOnly,
    );

    Navigator.of(
      context,
    ).pop<TaskWithEntryModel>(TaskWithEntryModel(task: model, entry: entry));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Task"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton.icon(
              onPressed: () {
                if (_titleController.text.trim().isNotEmpty) {
                  _onSave();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.errorContainer,
                      content: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Theme.of(
                              context,
                            ).colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Please enter task name.',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
              label: const Text("Create"),
              icon: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: IconButton(
                onPressed: () async {
                  // Show icon picker
                  final icon = await showIconPicker(
                    context,
                    AppIcons.categorizedIcons,
                  );

                  if (icon != null) {
                    setState(() {
                      _iconIndex = icon;
                    });
                  }
                },
                icon: Icon(AppIcons.icons[_iconIndex]),
                iconSize: 36,
                padding: const EdgeInsets.all(32),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            RoutineTaskTitle(controller: _titleController),
            const SizedBox(height: 16),
            RoutineTaskDuration(
              duration: duration,
              onStartTimeChanged: (p0) => setState(() => duration = p0),
            ),
          ],
        ),
      ),
    );
  }
}
