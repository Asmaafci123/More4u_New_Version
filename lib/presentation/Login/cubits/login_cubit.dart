import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:more4u/domain/usecases/login_user.dart';
import '../../../domain/entities/login_response.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  static LoginCubit get(context) => BlocProvider.of(context);
  final LoginUserUsecase loginUser;

  LoginCubit({required this.loginUser}) : super(InitialLoginState());

  TextEditingController userNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isTextVisible = false;
  int languageCode=1;
  LoginResponse? loginResponse = null;

  void changeTextVisibility(bool value) {
    isTextVisible = value;
    emit(ChangePasswordVisibilityState());
  }

  void login() async {
    emit(LoginLoadingState());
    final result = await loginUser(
      languageCode:languageCode,
        userNumber:userNumberController.text,
        pass: passwordController.text);
    result.fold((failure) {
      emit(LoginErrorState(failure.message));
    }, (loginResponse) {
      languageId=languageCode;
      userNumber=loginResponse.userNumber;
      emit(LoginSuccessState(loginResponse));
    });
  }
  String dropdownvalue = 'English';
  void changeAppLanguage(String value)
  {
    dropdownvalue=value;
    if(value=='English')
      {
        languageCode=1;
      }
    else
      {
        languageCode=2;
      }
  }
}
