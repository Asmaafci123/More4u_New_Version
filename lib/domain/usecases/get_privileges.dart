import 'package:dartz/dartz.dart';


import '../entities/privilege.dart';
import '../repositories/user_repository.dart';
import '../../core/errors/failures.dart';



class GetPrivilegesUsecase {
  UserRepository repository;

  GetPrivilegesUsecase(this.repository);

  Future<Either<Failure, List<Privilege>>> call(String? token) {
    return repository.getPrivileges(token);
  }
}
