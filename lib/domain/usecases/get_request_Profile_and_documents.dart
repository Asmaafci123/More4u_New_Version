import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/profile_and_documents.dart';

import '../../core/errors/failures.dart';
import '../repositories/benefit_repository.dart';

class GetRequestProfileAndDocumentsUsecase {
  BenefitRepository repository;

  GetRequestProfileAndDocumentsUsecase(this.repository);

  Future<Either<Failure, ProfileAndDocuments>> call({
    required int userNumber,
    required int requestNumber,
    String? token,
    required int languageCode,

  }) {
    return repository.getRequestProfileAndDocuments(
      token:token,
        userNumber: userNumber,requestNumber:requestNumber,languageCode: languageCode);
  }
}