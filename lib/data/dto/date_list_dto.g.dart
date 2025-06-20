// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateListDto _$DateListDtoFromJson(Map<String, dynamic> json) => DateListDto(
  dates: (json['dates'] as List<dynamic>)
      .map((e) => DateTime.parse(e as String))
      .toList(),
);

Map<String, dynamic> _$DateListDtoToJson(DateListDto instance) =>
    <String, dynamic>{
      'dates': instance.dates.map((e) => e.toIso8601String()).toList(),
    };
