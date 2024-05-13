import '../../domain/entities/gift.dart';

class GiftModel extends Gift {
  const GiftModel({
    int? requestNumber,
    int? userNumber,
    String? userName,
    String? benefitName,
    String? benefitCard,
    String? userDepartment,
    String? userEmail,
    String? date,
  }) : super(
          requestNumber: requestNumber,
          userNumber: userNumber,
          userName: userName,
          benefitName: benefitName,
          benefitCard: benefitCard,
          userDepartment: userDepartment,
          userEmail: userEmail,
          date: date,
        );

  factory GiftModel.fromJson(Map<String, dynamic> json) => GiftModel(
        requestNumber: json["requestNumber"],
        userNumber: json["userNumber"],
        userName: json["userName"],
        benefitName: json["benefitName"],
        benefitCard: json["benefitCard"],
        userDepartment: json["userDepartment"],
        userEmail: json["userEmail"],
        date: json["date"],
      );
}
