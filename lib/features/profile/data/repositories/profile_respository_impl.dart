import 'package:mobile/features/profile/data/providers/profile_data_provider.dart';
import 'package:mobile/features/profile/domain/entities/profile_change_password_params.dart';
import 'package:mobile/features/profile/domain/entities/user_entity.dart';
import 'package:mobile/features/profile/domain/repositories/profile_repository.dart';

class ProfileRespositoryImpl implements ProfileRepository {
  final ProfileDataProvider _provider;
  ProfileRespositoryImpl({required ProfileDataProvider provider})
    : _provider = provider;
  @override
  Future<UserEntity> changePassword(ProfileChangePasswordParams params) {
    return _provider.changePassword(params);
  }

  @override
  Future<UserEntity> getUser() {
    return _provider.getUser();
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) {
    return _provider.updateUser(user);
  }
}
