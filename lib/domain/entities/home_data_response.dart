import 'package:equatable/equatable.dart';
import 'package:more4u/domain/entities/token.dart';

import 'user.dart';
import 'benefit.dart';

class HomeDataResponse extends Equatable {
  final String message;
  final User user;
  final List<Benefit> benefitModels;
  final List<Benefit>? availableBenefitModels;
  final int userUnSeenNotificationCount;
  final int priviligesCount;
  const HomeDataResponse(
      {required this.message,
        required this.user,
        required this.benefitModels,
        required this.availableBenefitModels,
        required this.userUnSeenNotificationCount,
        required this.priviligesCount,
      });

  @override
  List<Object?> get props =>
      [message, user, benefitModels, availableBenefitModels,userUnSeenNotificationCount];
}
