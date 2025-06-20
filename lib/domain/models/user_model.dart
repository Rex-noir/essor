class UserModel {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.avatarUrl,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
