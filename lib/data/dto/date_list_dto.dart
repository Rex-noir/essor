import 'package:json_annotation/json_annotation.dart';

part 'date_list_dto.g.dart';

@JsonSerializable()
class DateListDto {
  final List<DateTime> dates;

  DateListDto({required this.dates});

  factory DateListDto.fromJson(Map<String, dynamic> json) =>
      _$DateListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DateListDtoToJson(this);
}
