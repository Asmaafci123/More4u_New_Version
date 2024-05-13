import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final int? userNumber;
  final String? userFullName;
  final String? userProfilePicture;
  final String? notificationType;
  final String? message;
  final String? requestStatus;
  final String? date;
  final int? requestNumber;
  final int? benefitId;

  const Notification({
    this.userNumber,
    this.userFullName,
    this.userProfilePicture,
    this.notificationType,
    this.message,
    this.requestStatus,
    this.date,
    this.requestNumber,
    this.benefitId,
  });

  @override
  List<Object?> get props => [
    userNumber,
    userFullName,
    userProfilePicture,
        notificationType,
        message,
        requestStatus,
        date,
        requestNumber,
        benefitId,
      ];
}
