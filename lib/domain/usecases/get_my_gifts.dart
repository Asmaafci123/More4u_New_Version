import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/benefit_repository.dart';
import '../entities/gift.dart';



class GetMyGiftsUsecase {
  BenefitRepository repository;

  GetMyGiftsUsecase(this.repository);

  Future<Either<Failure, List<Gift>>> call({
    required int userNumber,
    required int requestNumber,
    required int languageCode,
    String? token
  }) {
    return repository.getMyGifts(
        userNumber: userNumber,
        requestNumber:requestNumber,
        languageCode:languageCode,
      token:token
    );
  }
}
