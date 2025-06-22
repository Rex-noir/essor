class TaskEntryModel {
  final String id;
  final String taskId;
  final DateTime entryDate;
  final bool completed;

  TaskEntryModel({
    required this.id,
    required this.taskId,
    required this.entryDate,
    required this.completed,
  });

  TaskEntryModel copyWith({
    String? id,
    String? taskId,
    DateTime? entryDate,
    bool? completed,
  }) {
    return TaskEntryModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      entryDate: entryDate ?? this.entryDate,
      completed: completed ?? this.completed,
    );
  }

  @override
  String toString() {
    return 'TaskEntryModel(id: $id, taskId: $taskId, entryDate: $entryDate, completed: $completed)';
  }
}
