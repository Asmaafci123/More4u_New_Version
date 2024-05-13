import 'package:more4u/domain/entities/login_response.dart';

abstract class LoginStates {}

class InitialLoginState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  late LoginResponse loginResponse;
  LoginSuccessState(this.loginResponse);
}

class LoginErrorState extends LoginStates {
  String? message;
  LoginErrorState(this.message);
}

class ChangePasswordVisibilityState extends LoginStates {}
class ChangeAppLanguageState extends LoginStates {}
