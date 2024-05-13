import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:more4u/data/models/benefit_request_model.dart';
import 'package:more4u/domain/entities/benefit.dart';
import 'package:more4u/domain/entities/benefit_request.dart';
import 'package:more4u/domain/entities/filtered_search.dart';
import 'package:more4u/domain/entities/notification.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/gift.dart';
import '../../domain/entities/manage_requests_response.dart';
import '../../domain/entities/profile_and_documents.dart';
import '../../domain/repositories/benefit_repository.dart';
import '../datasources/remote_data_source.dart';

class BenefitRepositoryImpl extends BenefitRepository {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BenefitRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, Benefit>> getBenefitDetails(
      {required int benefitId}) async {
    if (await networkInfo.isConnected) {
      try {
        Benefit result =
            await remoteDataSource.getBenefitDetails(benefitId: benefitId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, List<Benefit>>> getMyBenefits(
      {required int userNumber,
      required int languageCode,
      String? token}) async {
    if (await networkInfo.isConnected) {
      try {
        List<Benefit> result = await remoteDataSource.getMyBenefits(
            userNumber: userNumber, languageCode: languageCode, token: token);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, List<Gift>>> getMyGifts(
      {required int userNumber,
      required int requestNumber,
      required int languageCode,
        String? token
      }) async {
    if (await networkInfo.isConnected) {
      try {
        List<Gift> result = await remoteDataSource.getMyGifts(
            userNumber: userNumber,
            requestNumber: requestNumber,
            languageCode: languageCode,
          token:token
        );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, List<BenefitRequest>>> getMyBenefitRequests(
      {required int userNumber,
      required int benefitId,
      int? requestNumber,
      required int languageCode,
      String? token}) async {
    if (await networkInfo.isConnected) {
      try {
        List<BenefitRequest> result =
            await remoteDataSource.getMyBenefitRequests(
                userNumber: userNumber,
                benefitId: benefitId,
                requestNumber: requestNumber,
                languageCode: languageCode,
                token: token
            );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, String>> cancelRequest(
      {required int userNumber,
      required int benefitId,
      required int requestNumber,
      required int languageCode,
        String? token
      }) async {
    if (await networkInfo.isConnected) {
      try {
        String result = await remoteDataSource.cancelRequest(
            userNumber: userNumber,
            benefitId: benefitId,
            requestNumber: requestNumber,
            languageCode: languageCode,
          token:token
        );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, String>> addResponse(
      {required int userNumber,
      required int status,
      required int requestWorkflowId,
      required String message,
      required int languageCode,
      String? token}) async {
    if (await networkInfo.isConnected) {
      try {
        String result = await remoteDataSource.addResponse(
            userNumber: userNumber,
            status: status,
            message: message,
            requestWorkflowId: requestWorkflowId,
            languageCode: languageCode,
            token: token);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, ManageRequestsResponse>> getBenefitsToManage(
      {required int userNumber,
      FilteredSearch? search,
      int? requestNumber,
      String? token,
      required int languageCode}) async {
    if (await networkInfo.isConnected) {
      try {
        ManageRequestsResponse result =
            await remoteDataSource.getBenefitsToManage(
                userNumber: userNumber,
                search: search,
                token: token,
                requestNumber: requestNumber,
                languageCode: languageCode);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
      return Left(ServerFailure(AppStrings.someThingWentWrong.tr()));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, ProfileAndDocuments>> getRequestProfileAndDocuments(
      {required int userNumber,
      required int requestNumber,
        required int languageCode,
      String? token}) async {
    if (await networkInfo.isConnected) {
      try {
        ProfileAndDocuments result =
            await remoteDataSource.getRequestProfileAndDocuments(
                token: token,
                userNumber: userNumber,
                requestNumber: requestNumber,
              languageCode: languageCode
            );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else{
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, Unit>> redeemCard(
      {required BenefitRequest request, String? token}) async {
    if (await networkInfo.isConnected) {
      try {
        BenefitRequestModel myBenefitRequestModel =
            BenefitRequestModel.fromEntity(request);

        await remoteDataSource.redeemCard(
            requestModel: myBenefitRequestModel, token: token);

        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, List<Notification>>> getNotifications(
      {required int userNumber, required int languageCode,String? token}) async {
    if (await networkInfo.isConnected) {
      try {
        List<Notification> notifications =
            await remoteDataSource.getNotifications(
                userNumber: userNumber, languageCode: languageCode,token:token);
        return Right(notifications);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }
}
