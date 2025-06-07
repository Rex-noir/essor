// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TaskEntity with EquatableMixin {
  final String title;
  final String description;
  final DateTime startDate;
  final TimeOfDay startTime;
  final bool isCompleted;
  final int importance;

  TaskEntity({
    required this.title,
    required this.description,
    required this.startDate,
    required this.startTime,
    required this.isCompleted,
    required this.importance,
  });

  TaskEntity copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    TimeOfDay? startTime,
    bool? isCompleted,
    int? importance,
  }) {
    return TaskEntity(
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      isCompleted: isCompleted ?? this.isCompleted,
      importance: importance ?? this.importance,
    );
  }

  @override
  List<Object> get props {
    return [title, description, startDate, startTime, isCompleted, importance];
  }
}
