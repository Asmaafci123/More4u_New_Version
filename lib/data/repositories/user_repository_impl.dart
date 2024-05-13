import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:more4u/core/constants/app_strings.dart';
import 'package:more4u/domain/entities/mobile_version.dart';
import 'package:more4u/domain/entities/user.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../core/constants/constants.dart';
import '../../domain/entities/home_data_response.dart';
import '../../domain/entities/privilege.dart';
import '../../domain/entities/login_response.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local_data_source/secure_local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../datasources/local_data_source/local_data_source.dart';
import '../models/home_data_response_model.dart';
import '../models/login_response_model.dart';
import '../models/medical-response-model.dart';

class UserRepositoryImpl extends UserRepository {
  final LocalDataSource localDataSource;
  final SecureStorage secureStorage;
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl(
      {required this.localDataSource,
        required this.secureStorage,
      required this.remoteDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, LoginResponse>> loginUser(
      {required String userNumber, required String pass,required int languageCode}) async {
    if (await networkInfo.isConnected) {
      try {
        LoginResponseModel result = await remoteDataSource.loginUser(
            userNumber: userNumber, pass: pass,languageCode:languageCode);
        secureStorage.writeSecureData('user id', userNumber);
        secureStorage.writeSecureData('user accessToken',result.tokenModel.accessToken );
        secureStorage.writeSecureData('user refreshToken',result.tokenModel.refreshToken );
        localDataSource.cacheAppLanguage(languageCode);
        accessToken=await secureStorage.readSecureData('user accessToken');
        refreshToken=await secureStorage.readSecureData('user refreshToken');
        return Right(result);
      }on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch(e){
        return Left(ServerFailure(AppStrings.serverIsDown.tr()));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }


  @override
  Future<Either<Failure, HomeDataResponse>> getHomeData(
      {required String userNumber,String? token,required int languageCode}) async {
    if (await networkInfo.isConnected) {
      try {
        HomeDataResponseModel result = await remoteDataSource.getHomeData(
            userNumber: userNumber, token: token,languageCode:languageCode);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch(e){
        return Left(ServerFailure(AppStrings.serverIsDown.tr()));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, String>> getUserProfilePicture({
    required int userNumber,
    String? token,
    required int languageCode
  }) async {
    if (await networkInfo.isConnected) {
      try {
        String result = await remoteDataSource.getUserProfilePicture(
            userNumber: userNumber,
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

  @override
  Future<Either<Failure, User>> updateProfilePicture(
      {required int userNumber, required String photo,String? token,required int languageCode}) async {
    if (await networkInfo.isConnected) {
      try {
        User result = await remoteDataSource.updateProfilePicture(
            userNumber: userNumber, photo: photo,token:token,languageCode: languageCode);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, String>> changePassword(
      {required int userNumber,
      required String oldPassword,
      required String newPassword,
      required String confirmPassword,
        String? token,
        required int languageCode,
      }) async {
    if (await networkInfo.isConnected) {
      try {
        String result = await remoteDataSource.changePassword(
            userNumber: userNumber,
            oldPassword: oldPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword,
          token:token,
          languageCode: languageCode
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
  Future<Either<Failure, List<Privilege>>> getPrivileges(String? token) async {
    if (await networkInfo.isConnected) {
      try {
        List<Privilege> privileges = await remoteDataSource.getPrivileges(token);
        return Right(privileges);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, MobileVersion>> getLastMobileVersion() async {
    if (await networkInfo.isConnected) {
      try {
        MobileVersion mobileVersion = await remoteDataSource.getLastMobileVersion();
        return Right(mobileVersion);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }

  @override
  Future<Either<Failure,MedicalResponseModel>> getMedical({
    String? token,required int languageCode, required String userNumber, }) async {
    if (await networkInfo.isConnected) {
      try {
        final result= await remoteDataSource.getMedical(
            token:token,languageCode:languageCode,userNumber: userNumber );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }

  @override
  Future<Either<Failure,String>> getTermsAndConditions({ required int languageCode,}) async {
    if (await networkInfo.isConnected) {
      try {
        final result= await remoteDataSource.getTermsAndConditions(languageCode: languageCode);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternetConnection.tr()));
    }
  }
}
