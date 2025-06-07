// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobile/features/daily_items/domain/entities/task_entity.dart';

class TaskDto with EquatableMixin {
  final String title;
  final String description;
  final DateTime startDate;
  final TimeOfDay startTime;
  final bool isCompleted;
  final int importance;

  TaskDto({
    required this.title,
    required this.description,
    required this.startDate,
    required this.startTime,
    required this.isCompleted,
    required this.importance,
  });

  TaskDto copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    TimeOfDay? startTime,
    bool? isCompleted,
    int? importance,
  }) {
    return TaskDto(
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      isCompleted: isCompleted ?? this.isCompleted,
      importance: importance ?? this.importance,
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      title: title,
      description: description,
      startDate: startDate,
      startTime: startTime,
      isCompleted: isCompleted,
      importance: importance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'startDate': startDate.millisecondsSinceEpoch,
      'start_time': {'hour': startTime.hour, 'minute': startTime.minute},
      'isCompleted': isCompleted,
      'importance': importance,
    };
  }

  factory TaskDto.fromMap(Map<String, dynamic> map) {
    return TaskDto(
      title: map['title'] as String,
      description: map['description'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      startTime: TimeOfDay(
        hour: map['start_time']['hour'] as int,
        minute: map['start_time']['minute'] as int,
      ),
      isCompleted: map['isCompleted'] as bool,
      importance: map['importance'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskDto.fromJson(String source) =>
      TaskDto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [title, description, startDate, startTime, isCompleted, importance];
  }
}
