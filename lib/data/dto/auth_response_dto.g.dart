// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseDto _$AuthResponseDtoFromJson(Map<String, dynamic> json) =>
    AuthResponseDto(
      UserDto.fromJson(json['data'] as Map<String, dynamic>),
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      deviceId: json['deviceId'] as String,
    );

Map<String, dynamic> _$AuthResponseDtoToJson(AuthResponseDto instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'data': instance.data,
      'deviceId': instance.deviceId,
    };
