import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/benefit_request.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/benefit.dart';
import '../entities/filtered_search.dart';
import '../entities/gift.dart';
import '../entities/manage_requests_response.dart';
import '../entities/notification.dart';
import '../entities/profile_and_documents.dart';

abstract class BenefitRepository {
  Future<Either<Failure, Benefit>> getBenefitDetails({
    required int benefitId,
  });

  Future<Either<Failure, List<Benefit>>> getMyBenefits({
    required int userNumber,
    required int languageCode,
    String? token
  });

  Future<Either<Failure, List<BenefitRequest>>> getMyBenefitRequests({
    required int userNumber,
    required int benefitId,
    int? requestNumber,
    required int languageCode,
    String? token
  });

  Future<Either<Failure, List<Gift>>> getMyGifts({
    required int userNumber,
    required int requestNumber,
    required int languageCode,
    String? token
  });


  Future<Either<Failure, String>> cancelRequest({
    required int userNumber,
    required int benefitId,
    required int requestNumber,
    required int languageCode,
    String? token
  });

  Future<Either<Failure, String>> addResponse({
    required int userNumber,
    required int status,
    required int requestWorkflowId,
    required String message,
    required int languageCode,
    String? token
  });

  Future<Either<Failure, ManageRequestsResponse>> getBenefitsToManage({
    required int userNumber,
    FilteredSearch? search,
    int? requestNumber,
    String? token,
    required int languageCode
  });

  Future<Either<Failure, ProfileAndDocuments>> getRequestProfileAndDocuments({
    required int userNumber,
    required int requestNumber,
    String?token,
    required int languageCode
  });


  Future<Either<Failure, Unit>> redeemCard({
    required BenefitRequest request,
    String? token
  });

  Future<Either<Failure, List<Notification>>> getNotifications({
    required int userNumber,
    required int languageCode,
    String? token
  });
}
