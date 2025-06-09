
import 'package:mobile/domain/entities/user_entity.dart';
import 'package:mobile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository _profileRepository;

  GetProfileUseCase(this._profileRepository);

  Future<UserEntity> call() async {
    return await _profileRepository.getUser();
  }
}
