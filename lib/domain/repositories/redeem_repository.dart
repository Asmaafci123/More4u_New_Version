import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/participant.dart';
import '../../../../../core/errors/failures.dart';
abstract class RedeemRepository {
  Future<Either<Failure, List<Participant>>> getParticipants(  {required int userNumber,
    required int benefitId,
    required bool isGift,
    String?token,
    required int languageCode
  });
}
