import 'package:more4u/domain/entities/token.dart';

class TokenModel extends Token {
  const TokenModel({accessToken, refreshToken})
      : super(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
