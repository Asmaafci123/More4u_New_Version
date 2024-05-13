import 'package:more4u/data/models/token_model.dart';
import 'package:more4u/domain/entities/benefit.dart';

import 'package:more4u/domain/entities/user.dart';

import '../../domain/entities/home_data_response.dart';
import '../../domain/entities/token.dart';
import './user_model.dart';
import 'benefit_model.dart';

class HomeDataResponseModel extends HomeDataResponse {
  HomeDataResponseModel({
    required String message,
    required User user,
    required List<Benefit> benefitModels,
    required List<Benefit>? availableBenefitModels,
    required int userUnSeenNotificationCount,
    required int priviligesCount,
  }) : super(
      message: message,
      user: user,
      benefitModels: benefitModels,
      availableBenefitModels: availableBenefitModels,
      userUnSeenNotificationCount: userUnSeenNotificationCount,
      priviligesCount: priviligesCount,
  );

  factory HomeDataResponseModel .fromJson(Map<String, dynamic> json) {
    return HomeDataResponseModel(
      message: json['message'],
      user: UserModel.fromJson(json['data']['user']),
      benefitModels: List<BenefitModel>.from(json['data']['allBenefitModels']
          .map((x) => BenefitModel.fromJson(x))
          .toList()),
      availableBenefitModels: json['data']['availableBenefitModels'] != null
          ? List<BenefitModel>.from(json['data']['availableBenefitModels']
          .map((x) => BenefitModel.fromJson(x))
          .toList())
          : null,
      userUnSeenNotificationCount: json['data']['userUnSeenNotificationCount'],
      priviligesCount: json['data']['priviligesCount'],
    );
  }
}
