import 'package:more4u/data/models/token_model.dart';
import '../../domain/entities/token.dart';
import '../../domain/entities/login_response.dart';

class LoginResponseModel extends LoginResponse {
  LoginResponseModel(
      {required String message,
      required int userNumber,
      required Token tokenModel})
      : super(message: message, userNumber: userNumber, tokenModel: tokenModel);

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'],
      userNumber: json['data']['userNumber'],
      tokenModel: TokenModel.fromJson(json['data']['tokenModel']),
    );
  }
}
