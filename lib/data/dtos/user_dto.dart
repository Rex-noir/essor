// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:mobile/features/profile/domain/entities/user_entity.dart';

class UserDTO extends Equatable {
  final String id;
  final String name;
  final String email;
  const UserDTO({required this.id, required this.name, required this.email});

  UserDTO copyWith({String? id, String? name, String? email}) {
    return UserDTO(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'email': email};
  }

  factory UserDTO.fromMap(Map<String, dynamic> map) {
    return UserDTO(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDTO.fromJson(String source) =>
      UserDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, email];

  UserEntity toEntity() {
    return UserEntity(id: id, name: name, email: email);
  }

  factory UserDTO.fromEntity(UserEntity entity) {
    return UserDTO(id: entity.id, name: entity.name, email: entity.email);
  }
}
