import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/data/dto/user_dto.dart';
import 'package:mobile/domain/models/auth_response_entity.dart';

part 'auth_response_dto.g.dart';

@JsonSerializable()
class AuthResponseDto {
  final String token;
  final String refreshToken;
  final UserDto data;
  final String deviceId;

  AuthResponseDto(
    this.data, {
    required this.token,
    required this.refreshToken,
    required this.deviceId,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseDtoToJson(this);
  AutheResponseModel toEntity() {
    return AutheResponseModel(
      accessToken: token,
      refreshToken: refreshToken,
      deviceId: deviceId,
      data: data.toModel(),
    );
  }
}
