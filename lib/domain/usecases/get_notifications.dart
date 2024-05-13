import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/notification.dart';
import '../repositories/benefit_repository.dart';
import '../../core/errors/failures.dart';

class GetNotificationsUsecase {
  BenefitRepository repository;

  GetNotificationsUsecase(this.repository);

  Future<Either<Failure, List<Notification>>> call({
    required int userNumber,
    required int languageCode,
    String? token
}) {
    return repository.getNotifications(
        userNumber: userNumber,
    languageCode:languageCode,
      token:token
    );
  }
}
