import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/benefit_repository.dart';

class CancelRequestsUsecase {
  BenefitRepository repository;

  CancelRequestsUsecase(this.repository);

  Future<Either<Failure, String>> call({
    required int userNumber,
    required int benefitId,
    required int requestNumber,
    required int languageCode,
    String? token
  }) {
    return repository.cancelRequest(
        userNumber: userNumber,
        benefitId: benefitId,
        requestNumber: requestNumber,
      languageCode:languageCode,
      token:token
    );
  }
}
