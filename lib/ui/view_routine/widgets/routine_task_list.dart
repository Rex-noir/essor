import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/config/app_icons.dart';
import 'package:mobile/core/extensions/date_extensions.dart';
import 'package:mobile/domain/models/task_model.dart';
import 'package:mobile/domain/models/task_with_entry_model.dart';
import 'package:mobile/ui/view_routine/bloc/view_routine_bloc.dart';
import 'package:mobile/ui/view_routine/screens/view_routine_task_screen.dart';
import 'package:mobile/ui/view_routine/widgets/routine_task_duration.dart';

class RoutineTaskList extends StatelessWidget {
  const RoutineTaskList({
    super.key,
    required this.tasks,
    required this.theme,
    required this.onReorderCompleted,
  });

  final List<TaskWithEntryModel> tasks;
  final ThemeData theme;
  final void Function(List<TaskWithEntryModel>) onReorderCompleted;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: tasks.length,
      onReorder: _onReorder,
      buildDefaultDragHandles: false,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isCompleted = task.entry?.completed ?? false;

        return Padding(
          key: ValueKey(tasks[index].task.id), // must be stable and unique
          padding: const EdgeInsets.only(bottom: 8),
          child: _TaskItem(
            task: task,
            theme: theme,
            isCompleted: isCompleted,
            index: index,
          ),
        );
      },
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    final updated = List<TaskWithEntryModel>.from(tasks);

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final movedTask = updated.removeAt(oldIndex);
    updated.insert(newIndex, movedTask);

    final reordered = updated.asMap().entries.map((entry) {
      final i = entry.key;
      final model = entry.value;
      return model.copyWith(task: model.task.copyWith(order: i));
    }).toList();

    // Let parent handle dispatching event and updating state
    onReorderCompleted(reordered);
  }
}

class _TaskItem extends StatefulWidget {
  final TaskWithEntryModel task;
  final ThemeData theme;
  final bool isCompleted;
  final int index;

  const _TaskItem({
    required this.task,
    required this.theme,
    required this.isCompleted,
    required this.index,
  });

  @override
  State<_TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<_TaskItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = widget.theme.colorScheme;
    final textTheme = widget.theme.textTheme;

    return Dismissible(
      key: Key(widget.task.task.id),
      background: _buildDismissBackground(isLeft: true),
      secondaryBackground: _buildDismissBackground(isLeft: false),
      onDismissed: (direction) => _onTaskRemoved(context),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: widget.isCompleted
                    ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isCompleted
                      ? colorScheme.primary.withValues(alpha: 0.3)
                      : colorScheme.outline.withValues(alpha: 0.1),
                  width: widget.isCompleted ? 1.5 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isCompleted
                        ? colorScheme.primary.withValues(alpha: 0.1)
                        : colorScheme.surfaceContainerHighest,
                  ),
                  child: Icon(
                    AppIcons.icons[widget.task.task.iconIndex],
                    size: 20,
                    color: widget.isCompleted
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                title: Text(
                  widget.task.task.title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: widget.isCompleted
                        ? colorScheme.onSurface.withValues(alpha: 0.7)
                        : colorScheme.onSurface,
                    decoration: widget.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: colorScheme.onSurface.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: 14,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formatTaskDuration(widget.task.task.duration),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    _CustomCheckbox(
                      value: widget.isCompleted,
                      onChanged: (value) => _onTaskToggled(context, value),
                      colorScheme: colorScheme,
                    ),
                    ReorderableDragStartListener(
                      index: widget.index,
                      child: Icon(
                        Icons.drag_handle,
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                onTap: () => _navigateToTaskDetails(context),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDismissBackground({required bool isLeft}) {
    final colorScheme = widget.theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.error,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete_outline,
              color: colorScheme.onError,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Delete',
            style: widget.theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onErrorContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _onTaskRemoved(BuildContext context) {
    context.read<ViewRoutineBloc>().add(
      ViewRoutineTaskRemoved(widget.task.task),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: widget.theme.colorScheme.errorContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: widget.theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete,
                color: widget.theme.colorScheme.onError,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Task "${widget.task.task.title}" removed',
                style: TextStyle(
                  color: widget.theme.colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: widget.theme.colorScheme.primary,
          onPressed: () {
            // Add undo functionality if needed
          },
        ),
      ),
    );
  }

  void _onTaskToggled(BuildContext context, bool? value) {
    context.read<ViewRoutineBloc>().add(
      ViewRoutineTaskUpdated(
        task: widget.task.task,
        date: DateTime.now().dateOnly,
        value: value ?? false,
      ),
    );
  }

  Future<void> _navigateToTaskDetails(BuildContext context) async {
    final bloc = context.read<ViewRoutineBloc>();

    final updatedTask = await Navigator.of(context).push<TaskModel>(
      MaterialPageRoute(
        builder: (_) => ViewRoutineTaskScreen(task: widget.task.task),
      ),
    );

    if (updatedTask != null) {
      bloc.add(
        ViewRoutineTaskUpdated(
          task: updatedTask,
          date: DateTime.now().dateOnly,
          value: widget.task.entry?.completed ?? false,
        ),
      );
    }
  }
}

class _CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final ColorScheme colorScheme;

  const _CustomCheckbox({
    required this.value,
    required this.onChanged,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value ? colorScheme.primary : Colors.transparent,
          border: value
              ? null
              : Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.5),
                  width: 2,
                ),
        ),
        child: value
            ? Icon(Icons.check, color: colorScheme.onPrimary, size: 16)
            : null,
      ),
    );
  }
}
