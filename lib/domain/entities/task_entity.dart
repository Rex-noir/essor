// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'item_entity.dart'; // assuming this file is named item_entity.dart

class TaskEntity extends ItemEntity {
  final bool isCompleted;
  final int importance;
  final Duration duration;

  const TaskEntity({
    required super.id,
    required super.title,
    super.description,
    this.isCompleted = false,
    required this.importance,
    required this.duration,
    super.iconIndex = 0,
  });

  @override
  List<Object?> get props => super.props + [isCompleted, importance];

  TaskEntity copyWith({
    bool? isCompleted,
    int? importance,
    Duration? duration,
    String? id,
    String? title,
  }) {
    return TaskEntity(
      title: title ?? this.title,
      id: id ?? this.id,
      isCompleted: isCompleted ?? this.isCompleted,
      importance: importance ?? this.importance,
      duration: duration ?? this.duration,
    );
  }
}
