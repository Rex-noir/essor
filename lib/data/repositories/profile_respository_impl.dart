
import 'package:mobile/domain/datasources/profile_datasource.dart';
import 'package:mobile/domain/entities/profile_change_password_params.dart';
import 'package:mobile/domain/entities/user_entity.dart';
import 'package:mobile/domain/repositories/profile_repository.dart';

class ProfileRespositoryImpl implements ProfileRepository {
  final ProfileDataSource _provider;
  ProfileRespositoryImpl({required ProfileDataSource provider})
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
