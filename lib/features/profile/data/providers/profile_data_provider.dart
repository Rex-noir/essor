import 'package:mobile/features/profile/domain/entities/profile_change_password_params.dart';
import 'package:mobile/features/profile/domain/entities/user_entity.dart';

abstract class ProfileDataProvider {
  Future<UserEntity> changePassword(ProfileChangePasswordParams params);
  Future<UserEntity> getUser();
  Future<UserEntity> updateUser(UserEntity entity);
}
