import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/login_response.dart';
import '../repositories/user_repository.dart';

class LoginUserUsecase {
  UserRepository repository;

  LoginUserUsecase(this.repository);

  Future<Either<Failure, LoginResponse>> call({
    required String userNumber,
    required String pass,
    required int languageCode
  }) {
    return repository.loginUser(
      languageCode:languageCode,
        userNumber: userNumber, pass: pass);
  }
}
