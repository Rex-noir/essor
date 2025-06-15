import 'dart:convert';

import 'package:mobile/domain/entities/item_entity.dart';
import 'package:mobile/domain/entities/task_entity.dart';

class TaskDto extends ItemEntity {
  final bool isCompleted;
  final Duration duration;

  const TaskDto({
    required super.id,
    required super.title,
    required this.duration,
    super.description,
    required super.iconIndex,
    this.isCompleted = false,
  });

  TaskDto copyWith({
    String? id,
    String? title,
    String? description,
    int? iconIndex,
    Duration? duration,
    bool? isCompleted,
  }) {
    return TaskDto(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      iconIndex: iconIndex ?? this.iconIndex,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_index': iconIndex,
      'is_completed': isCompleted,
      'duration': duration.inMinutes,
    };
  }

  factory TaskDto.fromMap(Map<String, dynamic> map) {
    return TaskDto(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      iconIndex: map['icon_index'],
      duration: Duration(minutes: map['duration']),
      isCompleted: map['is_completed'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskDto.fromJson(String source) =>
      TaskDto.fromMap(json.decode(source));

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      iconIndex: iconIndex,
      duration: duration,
      isCompleted: isCompleted,
      importance: 0, // ← You can expose this in DTO if needed
    );
  }

  @override
  List<Object?> get props => [id, title, description, iconIndex, isCompleted];
}
