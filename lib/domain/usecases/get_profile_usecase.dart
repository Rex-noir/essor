import 'package:mobile/domain/models/user_model.dart';
import 'package:mobile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository _profileRepository;

  GetProfileUseCase(this._profileRepository);

  Future<UserModel> call() async {
    return await _profileRepository.getUser();
  }
}
