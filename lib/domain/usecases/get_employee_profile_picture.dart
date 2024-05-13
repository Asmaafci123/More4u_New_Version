import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/user_repository.dart';


class GetUserProfilePictureUsecase {
  UserRepository repository;

  GetUserProfilePictureUsecase(this.repository);

  Future<Either<Failure, String>> call({
    required int userNumber,
    String? token,
    required int languageCode,
  }) {
    return repository.getUserProfilePicture(
      userNumber: userNumber,
      token:token,
      languageCode: languageCode
    );
  }
}
