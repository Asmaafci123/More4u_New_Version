import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/benefit_request.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/benefit_repository.dart';

class RedeemCardUsecase {
  BenefitRepository repository;

  RedeemCardUsecase(this.repository);

  Future<Either<Failure, Unit>> call({required BenefitRequest request,String?token}) {
    return repository.redeemCard(request: request,token:token);
  }
}
