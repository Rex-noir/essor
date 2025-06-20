import 'dart:async';

import 'package:mobile/domain/models/profile_change_password_params.dart';
import 'package:mobile/domain/models/user_model.dart';
import 'package:mobile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  UserModel _user = UserModel(
    id: 'user-001',
    name: 'Jane Doe',
    email: 'jane@example.com',
    avatarUrl: 'https://example.com/avatar.jpg',
  );

  @override
  Future<UserModel> getUser() async {
    await Future.delayed(const Duration(seconds: 1));
    return _user;
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    await Future.delayed(const Duration(seconds: 1));
    _user = user.copyWith();
    return _user;
  }

  @override
  Future<UserModel> changePassword(ProfileChangePasswordParams params) async {
    await Future.delayed(const Duration(seconds: 2));

    // Simulated check — in real life, you'd validate the current password
    if (params.currentPassword != 'valid_password') {
      throw Exception('Current password is incorrect');
    }

    // Simulate success
    _user = _user.copyWith();
    return _user;
  }
}
