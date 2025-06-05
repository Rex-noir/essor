// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:mobile/features/authentication/data/dtos/user_dto.dart';
import 'package:mobile/features/authentication/domain/entities/auth_response_entity.dart';

class AuthResponseDTO with EquatableMixin {
  final String accessToken;
  final String refreshToken;
  final String deviceId;
  final UserDTO data;
  const AuthResponseDTO({
    required this.accessToken,
    required this.refreshToken,
    required this.deviceId,
    required this.data,
  });

  AuthResponseDTO copyWith({
    String? accessToken,
    String? refreshToken,
    String? deviceId,
    UserDTO? data,
  }) {
    return AuthResponseDTO(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      deviceId: deviceId ?? this.deviceId,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'device_id': deviceId,
      'data': data.toMap(),
    };
  }

  factory AuthResponseDTO.fromMap(Map<String, Object?> map) {
    return AuthResponseDTO(
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String,
      deviceId: map['device_id'] as String,
      data: UserDTO.fromMap(map['data'] as Map<String, Object?>),
    );
  }

  String toJson() => json.encode(toMap());

  AuthResponseEntity toEntity() {
    return AuthResponseEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      deviceId: deviceId,
      data: data.toEntity(),
    );
  }

  factory AuthResponseDTO.fromJson(String source) =>
      AuthResponseDTO.fromMap(json.decode(source) as Map<String, Object?>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [accessToken, refreshToken, deviceId, data];
}
