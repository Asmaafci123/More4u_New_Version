import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/mobile_version.dart';
import '../../../../../core/errors/failures.dart';
import '../../data/models/medical-response-model.dart';
import '../entities/home_data_response.dart';
import '../entities/login_response.dart';
import '../entities/user.dart';
import '../entities/privilege.dart';


abstract class UserRepository {
  Future<Either<Failure,LoginResponse>> loginUser({
    required String userNumber,
    required String pass,
    required int languageCode,
  });

  Future<Either<Failure,HomeDataResponse>> getHomeData({
    required String userNumber,
   String? token,
    required int languageCode,
  });

  Future<Either<Failure,String>> getUserProfilePicture({
    required int userNumber,
    String? token,
    required int languageCode,
  });

  Future<Either<Failure,User>> updateProfilePicture({
    required int userNumber,
    required String photo,
    String? token,
    required int languageCode,
  });

  Future<Either<Failure,String>> changePassword({
    required int userNumber,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
    String? token,
    required int languageCode,
  });

  Future<Either<Failure,List<Privilege>>> getPrivileges(String? token);
  Future<Either<Failure,MobileVersion>> getLastMobileVersion();
  Future<Either<Failure,MedicalResponseModel>> getMedical({String? token,required int languageCode, required String userNumber,});

  Future<Either<Failure,String>> getTermsAndConditions({ required int languageCode,});
}
