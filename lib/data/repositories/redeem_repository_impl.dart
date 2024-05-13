import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:more4u/domain/entities/participant.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/repositories/redeem_repository.dart';
import '../datasources/remote_data_source.dart';

class RedeemRepositoryImpl extends RedeemRepository {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RedeemRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<Participant>>> getParticipants(
      {required int userNumber,
        required int benefitId,
        required bool isGift,
        String? token,
        required int languageCode
      }
      ) async {
    if (await networkInfo.isConnected) {
      try {
        List<Participant> result = await remoteDataSource.getParticipants(
          userNumber: userNumber,
          benefitId: benefitId,
          isGift: isGift,
          token:token,
          languageCode: languageCode
        );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return  Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }
}
