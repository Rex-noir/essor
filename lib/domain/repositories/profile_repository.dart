import 'package:mobile/domain/models/profile_change_password_params.dart';
import 'package:mobile/domain/models/user_model.dart';

abstract class ProfileRepository {
  Future<UserModel> getUser();
  Future<UserModel> updateUser(UserModel user);
  Future<UserModel> changePassword(ProfileChangePasswordParams params);
}
