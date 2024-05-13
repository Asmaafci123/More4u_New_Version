import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/filtered_search.dart';

import '../../core/errors/failures.dart';
import '../entities/manage_requests_response.dart';
import '../repositories/benefit_repository.dart';

class GetBenefitsToManageUsecase {
  BenefitRepository repository;

  GetBenefitsToManageUsecase(this.repository);

  Future<Either<Failure, ManageRequestsResponse>> call({
    required int userNumber,
    String? token,
    FilteredSearch? search,
    int? requestNumber,
    required int languageCode

  }) {
    return repository.getBenefitsToManage(
      token:token,
        userNumber: userNumber, search: search,requestNumber:requestNumber,languageCode:languageCode);
  }
}