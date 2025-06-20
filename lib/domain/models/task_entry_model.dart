class TaskEntryEntity {
  final String id;
  final String taskId;
  final DateTime entryDate;
  final bool completed;

  TaskEntryEntity({
    required this.id,
    required this.taskId,
    required this.entryDate,
    required this.completed,
  });

  TaskEntryEntity copyWith({
    String? id,
    String? taskId,
    DateTime? entryDate,
    bool? completed,
  }) {
    return TaskEntryEntity(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      entryDate: entryDate ?? this.entryDate,
      completed: completed ?? this.completed,
    );
  }
}
