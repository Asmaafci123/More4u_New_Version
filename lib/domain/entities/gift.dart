import 'package:equatable/equatable.dart';

class Gift extends Equatable {
  final int? requestNumber;
  final int? userNumber;
  final String? userName;
  final String? benefitName;
  final String? benefitCard;
  final String? userDepartment;
  final String? userEmail;
  final String? date;

  const Gift({
    this.requestNumber,
    this.userNumber,
    this.userName,
    this.benefitName,
    this.benefitCard,
    this.userDepartment,
    this.userEmail,
    this.date,
  });

  @override
  List<Object?> get props => [];
}
