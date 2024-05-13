import 'package:dartz/dartz.dart';
import 'package:more4u/core/constants/constants.dart';

import '../../core/errors/failures.dart';
import '../repositories/benefit_repository.dart';

class AddRequestResponseUsecase {
  BenefitRepository repository;

  AddRequestResponseUsecase(this.repository);

  Future<Either<Failure, String>> call({
    required int userNumber,
    required int status,
    required int requestWorkflowId,
    required String message,
    required int languageCode,
    String? token
  }) {
    return repository.addResponse(
      userNumber: userNumber,
      status: status,
      requestWorkflowId: requestWorkflowId,
      message: message,
      languageCode:languageCode,
      token:token
    );
  }
}
