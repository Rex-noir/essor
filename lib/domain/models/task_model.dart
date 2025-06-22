class TaskModel {
  final String id;
  final String title;
  final String? description;
  final int iconIndex;
  final int importance;
  final Duration duration;
  final String? routineId;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.iconIndex = 0,
    required this.importance,
    required this.duration,
    this.routineId,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    int? iconIndex,
    int? importance,
    Duration? duration,
    String? routineId,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconIndex: iconIndex ?? this.iconIndex,
      importance: importance ?? this.importance,
      duration: duration ?? this.duration,
      routineId: routineId ?? this.routineId,
    );
  }
  
  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, description: $description, '
        'iconIndex: $iconIndex, importance: $importance, duration: $duration, '
        'routineId: $routineId)';
  }
}
