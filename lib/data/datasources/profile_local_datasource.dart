import 'package:mobile/domain/entities/profile_change_password_params.dart';
import 'package:mobile/domain/entities/user_entity.dart';
import 'package:mobile/domain/datasources/profile_datasource.dart';

class ProfileLocalDataSource implements ProfileDataSource {
  @override
  Future<UserEntity> changePassword(ProfileChangePasswordParams params) async {
    // Simulate a password change and return the mock user
    return UserEntity(id: '1', name: 'Local User', email: 'local@example.com');
  }

  @override
  Future<UserEntity> getUser() async {
    // Return a dummy UserDTO from local source
    return UserEntity(id: '1', name: 'Local User', email: 'local@example.com');
  }

  @override
  Future<UserEntity> updateUser(UserEntity entity) async {
    // Simulate updating user and return the updated user as DTO
    return UserEntity(id: '1', name: 'Local User', email: 'local@example.com');
  }
}
