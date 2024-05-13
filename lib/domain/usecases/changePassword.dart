import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../repositories/user_repository.dart';

class ChangePasswordUsecase {
  UserRepository repository;

  ChangePasswordUsecase(this.repository);

  Future<Either<Failure, String>> call(
      {required int userNumber,
      required String oldPassword,
      required String newPassword,
      required String confirmPassword,
        String? token,
        required int languageCode,
      }) {
    return repository.changePassword(
        userNumber:userNumber,
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      token:token,
      languageCode: languageCode
    );
  }
}
