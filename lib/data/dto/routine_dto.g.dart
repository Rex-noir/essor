// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutineDto _$RoutineDtoFromJson(Map<String, dynamic> json) => RoutineDto(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  startTime: json['startTime'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  weeklyDays: (json['weeklyDays'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  frequency: $enumDecode(_$ItemFrequencyEnumMap, json['frequency']),
  monthlyDates: (json['monthlyDates'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  interval: (json['interval'] as num).toInt(),
  isShared: json['isShared'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  syncVersion: (json['syncVersion'] as num).toInt(),
  iconIndex: (json['iconIndex'] as num).toInt(),
);

Map<String, dynamic> _$RoutineDtoToJson(RoutineDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'startTime': instance.startTime,
      'startDate': instance.startDate.toIso8601String(),
      'weeklyDays': instance.weeklyDays,
      'frequency': _$ItemFrequencyEnumMap[instance.frequency]!,
      'monthlyDates': instance.monthlyDates,
      'interval': instance.interval,
      'isShared': instance.isShared,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'syncVersion': instance.syncVersion,
      'iconIndex': instance.iconIndex,
    };

const _$ItemFrequencyEnumMap = {
  ItemFrequency.daily: 'daily',
  ItemFrequency.weekly: 'weekly',
  ItemFrequency.monthly: 'monthly',
};
