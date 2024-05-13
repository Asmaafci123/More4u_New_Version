import 'package:equatable/equatable.dart';
import 'package:more4u/domain/entities/token.dart';

import 'user.dart';
import 'benefit.dart';

class LoginResponse extends Equatable {
  final String message;
  final int userNumber;
final Token  tokenModel;
  const LoginResponse(
      {required this.message,
      required this.userNumber,
        required this.tokenModel
      });

  @override
  List<Object?> get props =>
      [message, userNumber,tokenModel];
}
