import 'package:flutter/material.dart';
import 'item_entity.dart'; // assuming this file is named item_entity.dart

class TaskEntity extends ItemEntity {
  final DateTime startDate;
  final TimeOfDay startTime;
  final bool isCompleted;
  final int importance;

  const TaskEntity({
    required super.id,
    required super.title,
    super.description,
    required this.startDate,
    required this.startTime,
    this.isCompleted = false,
    required this.importance,
    required super.type,
    super.target,
    super.iconIndex = 0,
  });

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    TimeOfDay? startTime,
    bool? isCompleted,
    int? importance,
    int? iconIndex,
    ItemType? type,
    int? target,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      isCompleted: isCompleted ?? this.isCompleted,
      importance: importance ?? this.importance,
      type: type ?? this.type,
      target: target ?? this.target,
      iconIndex: iconIndex ?? this.iconIndex,
    );
  }

  @override
  List<Object?> get props => super.props + [startDate, startTime, isCompleted, importance];
}
