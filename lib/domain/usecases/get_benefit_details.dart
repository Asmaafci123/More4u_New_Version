import 'package:dartz/dartz.dart';
import 'package:more4u/domain/repositories/benefit_repository.dart';

import '../../core/errors/failures.dart';
import '../entities/benefit.dart';


class GetBenefitDetailsUsecase {
  BenefitRepository repository;

  GetBenefitDetailsUsecase(this.repository);

  Future<Either<Failure, Benefit>> call({
    required int benefitId,
  }) {
    return repository.getBenefitDetails(benefitId: benefitId);
  }
}
