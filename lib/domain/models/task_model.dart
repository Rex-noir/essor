class TaskModel {
  final String id;
  final String title;
  final String? description;
  final int iconIndex;
  final bool isCompleted;
  final int importance;
  final Duration duration;
  final int? routineId;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.iconIndex = 0,
    this.isCompleted = false,
    required this.importance,
    required this.duration,
    this.routineId,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    int? iconIndex,
    bool? isCompleted,
    int? importance,
    Duration? duration,
    int? routineId,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconIndex: iconIndex ?? this.iconIndex,
      isCompleted: isCompleted ?? this.isCompleted,
      importance: importance ?? this.importance,
      duration: duration ?? this.duration,
      routineId: routineId ?? this.routineId,
    );
  }
}
