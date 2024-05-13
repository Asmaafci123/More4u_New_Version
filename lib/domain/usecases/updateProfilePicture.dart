import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class UpdateProfilePictureUsecase {
  UserRepository repository;

  UpdateProfilePictureUsecase(this.repository);

  Future<Either<Failure, User>> call({
    required int userNumber,
    required String photo,
    String? token,
    required int languageCode
  }) {
    return repository.updateProfilePicture(
      token:token,
        userNumber: userNumber, photo: photo,languageCode: languageCode);
  }
}
