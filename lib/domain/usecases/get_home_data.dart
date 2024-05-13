import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/home_data_response.dart';
import '../repositories/user_repository.dart';

class HomeDataUseCase {
  UserRepository repository;

  HomeDataUseCase(this.repository);

  Future<Either<Failure, HomeDataResponse>> call({
    required String userNumber,
    String? token,
    required int languageCode
  }) {
    return repository.getHomeData(
        languageCode:languageCode,
        userNumber: userNumber,token: token);
  }
}
