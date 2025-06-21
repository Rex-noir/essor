import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/domain/models/routine_model.dart';

part 'routine_dto.g.dart';

@JsonSerializable()
class RoutineDto {
  final String id;
  final String title;
  final String? description;
  final String startTime; // Stored as string: "HH:mm"
  final DateTime startDate;
  final List<int> weeklyDays;
  final ItemFrequency frequency;
  final List<int> monthlyDates;
  final int interval;
  final bool isShared;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int syncVersion;
  final int iconIndex;

  @override
  String toString() => toJson().toString();

  RoutineDto({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.startDate,
    required this.weeklyDays,
    required this.frequency,
    required this.monthlyDates,
    required this.interval,
    required this.isShared,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.syncVersion,
    required this.iconIndex,
  });

  factory RoutineDto.fromJson(Map<String, dynamic> json) =>
      _$RoutineDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineDtoToJson(this);

  RoutineModel toModel() {
    final parts = startTime.split(":");
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return RoutineModel(
      id: id,
      title: title,
      description: description,
      startTime: TimeOfDay(hour: hour, minute: minute),
      startDate: startDate,
      weeklyDays: weeklyDays,
      frequency: frequency,
      monthlyDates: monthlyDates,
      interval: interval,
      isShared: isShared,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      syncVersion: syncVersion,
      iconIndex: iconIndex,
    );
  }

  factory RoutineDto.fromModel(RoutineModel model) {
    final formattedStartTime =
        "${model.startTime.hour.toString().padLeft(2, '0')}:${model.startTime.minute.toString().padLeft(2, '0')}";

    return RoutineDto(
      id: model.id,
      title: model.title,
      description: model.description,
      startTime: formattedStartTime,
      startDate: model.startDate,
      weeklyDays: model.weeklyDays,
      frequency: model.frequency,
      monthlyDates: model.monthlyDates,
      interval: model.interval,
      isShared: model.isShared,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      deletedAt: model.deletedAt,
      syncVersion: model.syncVersion,
      iconIndex: model.iconIndex,
    );
  }
}
