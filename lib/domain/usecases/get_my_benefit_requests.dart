import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/benefit_request.dart';
import 'package:more4u/domain/repositories/benefit_repository.dart';

import '../../core/errors/failures.dart';
class GetMyBenefitRequestsUsecase {
  BenefitRepository repository;

  GetMyBenefitRequestsUsecase(this.repository);

  Future<Either<Failure, List<BenefitRequest>>> call({
    required int userNumber,
    required int benefitId,
    int? requestNumber,
    required int languageCode,
    String? token
  }) {
    return repository.getMyBenefitRequests(
        userNumber: userNumber,
        benefitId: benefitId,
        requestNumber:requestNumber,
      languageCode:languageCode,
      token: token
    );
  }
}
