import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/user_repository.dart';

class GetTermsAndConditionsUseCase {
  UserRepository repository;

  GetTermsAndConditionsUseCase(this.repository);

  Future<Either<Failure, String>> call({
  required int languageCode
}) {
    return repository.getTermsAndConditions(languageCode: languageCode);
  }
}
