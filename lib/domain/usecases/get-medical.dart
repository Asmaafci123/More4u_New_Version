import 'package:dartz/dartz.dart';
import '../../data/models/medical-response-model.dart';

import '../repositories/user_repository.dart';
import '../../core/errors/failures.dart';



class GetMedicalUsecase {
  UserRepository repository;

  GetMedicalUsecase(this.repository);

  Future<Either<Failure, MedicalResponseModel>> call({String? token ,required int languageCode, required String userNumber,}) {
    return repository.getMedical(token:token,languageCode:languageCode,userNumber: userNumber);
  }
}
