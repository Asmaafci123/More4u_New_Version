import '../../domain/entities/notification.dart';

class NotificationModel extends Notification {
  const NotificationModel({
    userNumber,
    userFullName,
    userProfilePicture,
    notificationType,
    message,
    requestStatus,
    date,
    requestNumber,
    benefitId,
  }) : super(
    userNumber: userNumber,
    userFullName: userFullName,
    userProfilePicture: userProfilePicture,
    notificationType: notificationType,
    message: message,
    requestStatus: requestStatus,
    date: date,
    requestNumber: requestNumber,
    benefitId: benefitId,
  );

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        userNumber: json["userNumber"],
        userFullName: json["userFullName"],
        userProfilePicture: json["userProfilePicture"],
        notificationType: json["notificationType"],
        message: json["message"],
        requestStatus: json["requestStatus"],
        date: json["date"],
        requestNumber: json["requestNumber"],
        benefitId: json["benefitId"],
      );
}
