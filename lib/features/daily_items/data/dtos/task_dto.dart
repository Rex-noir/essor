import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/features/daily_items/domain/entities/item_entity.dart';
import 'package:mobile/features/daily_items/domain/entities/task_entity.dart';

class TaskDto extends ItemEntity {
  final DateTime startDate;
  final TimeOfDay startTime;
  final bool isCompleted;

  const TaskDto({
    required super.id,
    required super.title,
    super.description,
    required super.iconIndex,
    required super.type,
    super.target,
    required this.startDate,
    required this.startTime,
    this.isCompleted = false,
  });

  TaskDto copyWith({
    String? id,
    String? title,
    String? description,
    int? iconIndex,
    ItemType? type,
    int? target,
    DateTime? startDate,
    TimeOfDay? startTime,
    bool? isCompleted,
  }) {
    return TaskDto(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconIndex: iconIndex ?? this.iconIndex,
      type: type ?? this.type,
      target: target ?? this.target,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_index': iconIndex,
      'type': type.index,
      'target': target,
      'start_date': startDate.millisecondsSinceEpoch,
      'start_time_hour': startTime.hour,
      'start_time_minute': startTime.minute,
      'is_completed': isCompleted,
    };
  }

  factory TaskDto.fromMap(Map<String, dynamic> map) {
    return TaskDto(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      iconIndex: map['icon_index'],
      type: ItemType.values[map['type']],
      target: map['target'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['start_date']),
      startTime: TimeOfDay(
        hour: map['start_time_hour'],
        minute: map['start_time_minute'],
      ),
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
      type: type,
      target: target,
      startDate: startDate,
      startTime: startTime,
      isCompleted: isCompleted,
      importance: 0, // ← You can expose this in DTO if needed
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    iconIndex,
    type,
    target,
    startDate,
    startTime,
    isCompleted,
  ];
}
