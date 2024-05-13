import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/mobile_version.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/login_response.dart';
import '../repositories/user_repository.dart';

class GetMobileVersionUseCase {
  UserRepository repository;

  GetMobileVersionUseCase(this.repository);

  Future<Either<Failure, MobileVersion>> call() {
    return repository.getLastMobileVersion();
  }
}
