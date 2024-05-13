import 'package:dartz/dartz.dart';
import 'package:more4u/domain/repositories/benefit_repository.dart';

import '../../core/errors/failures.dart';
import '../entities/benefit.dart';


class GetMyBenefitsUsecase {
  BenefitRepository repository;

  GetMyBenefitsUsecase(this.repository);

  Future<Either<Failure, List<Benefit>>> call({
    required int userNumber,
    required int languageCode,
   String? token
  }) {
    return repository.getMyBenefits(userNumber: userNumber,languageCode:languageCode,token: token);
  }
}
