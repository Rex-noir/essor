import 'package:flutter/material.dart';
import 'package:mobile/core/config/app_icons.dart';
import 'package:mobile/core/ui/widgets/show_icon_picker.dart';
import 'package:mobile/domain/models/task_model.dart';
import 'package:mobile/ui/view_routine/widgets/routine_task_duration.dart';
import 'package:mobile/ui/view_routine/widgets/routine_task_title.dart';

class ViewRoutineTaskScreen extends StatefulWidget {
  final TaskModel task;
  const ViewRoutineTaskScreen({required this.task, super.key});

  @override
  State<ViewRoutineTaskScreen> createState() => _ViewRoutineTaskScreen();
}

class _ViewRoutineTaskScreen extends State<ViewRoutineTaskScreen> {
  late TextEditingController _titleController;
  late int _iconIndex;
  late Duration duration;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _iconIndex = widget.task.iconIndex;
    duration = widget.task.duration;
  }

  _onSave() {
    final TaskModel entity = TaskModel(
      duration: duration,
      id: widget.task.id,
      title: _titleController.text,
      iconIndex: _iconIndex,
      order: 1,
      routineId: widget.task.routineId,
    );

    Navigator.of(context).pop(entity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
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
              label: const Text("Save"),
              icon: Icon(Icons.save),
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
