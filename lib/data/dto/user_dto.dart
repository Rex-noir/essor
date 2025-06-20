import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/domain/models/user_model.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  final String id;
  final String name;
  final String email;

  const UserDto({required this.id, required this.name, required this.email});

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  UserModel toModel() =>
      UserModel(id: id, name: name, email: email, avatarUrl: null);

  static UserDto fromEntity(UserModel entity) =>
      UserDto(id: entity.id, name: entity.name, email: entity.email);
}
