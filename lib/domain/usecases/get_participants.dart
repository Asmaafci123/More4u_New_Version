import 'package:dartz/dartz.dart';

import '../entities/participant.dart';
import '../repositories/redeem_repository.dart';
import '../../core/errors/failures.dart';

class GetParticipantsUsecase {
  RedeemRepository repository;

  GetParticipantsUsecase(this.repository);

  Future<Either<Failure, List<Participant>>> call(  {required int userNumber,
    required int benefitId,
    required bool isGift,
    String?token,
    required int languageCode
  }) {
    return repository.getParticipants(
      userNumber: userNumber,
      benefitId: benefitId,
      isGift: isGift,
      token:token,
      languageCode: languageCode
    );
  }
}
