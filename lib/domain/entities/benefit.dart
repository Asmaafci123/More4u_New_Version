import 'package:equatable/equatable.dart';

class Benefit extends Equatable {
  final int id;
  final String name;
  final String benefitCardAPI;
  final int times;
  final int timesUserReceiveThisBenefit;
  final String benefitType;
  final bool userCanRedeem;

  //Data to use in details screen
  final String? description;
  final BenefitConditions? benefitConditions;
  final BenefitApplicable? benefitApplicable;
  final List<String>? benefitWorkflows;
  final List<String>? benefitDescriptionList;
  final String? title;

  //Data to use in Redeem
  final bool isAgift;
  final int minParticipant;
  final int maxParticipant;
  final List<String>? requiredDocumentsArray;
  final int? numberOfDays;
  final String? dateToMatch;
  final String? certainDate;
  final bool mustMatch;


  //other
  final String? lastStatus;
  final int? totalRequestsCount;
  final bool? hasHoldingRequests;

  const Benefit({
    required this.id,
    required this.name,
    required this.benefitCardAPI,
    required this.times,
    required this.timesUserReceiveThisBenefit,
    required this.userCanRedeem,
    required this.benefitType,
    this.description,
    this.benefitWorkflows,
    this.benefitDescriptionList,
    this.title,
    this.benefitConditions,
    this.benefitApplicable,
    required this.isAgift,
    required this.minParticipant,
    required this.maxParticipant,
    this.requiredDocumentsArray,
    this.numberOfDays,
    this.dateToMatch,
    this.certainDate,
    required this.mustMatch,
    this.lastStatus,
    this.totalRequestsCount,
    this.hasHoldingRequests,
  });

  @override
  List<Object?> get props => [
        id,
        name,
    benefitCardAPI,
        times,
        timesUserReceiveThisBenefit,
        userCanRedeem,
        benefitType,
        description,
        benefitWorkflows,
        benefitConditions,
        isAgift,
        minParticipant,
        maxParticipant,
        requiredDocumentsArray,
        dateToMatch,
        certainDate,
        lastStatus,
        totalRequestsCount,
        hasHoldingRequests,
      ];
}

class BenefitConditions extends Equatable {
  final String? type;
  final String? workDuration;
  final String? dateToMatch;
  final String? gender;
  final String? maritalStatus;
  final String? requiredDocuments;
  final String? age;
  final String? minParticipant;
  final String? maxParticipant;
  final String? payrollArea;

  const BenefitConditions(
      {this.type,
      this.workDuration,
      this.dateToMatch,
      this.gender,
      this.maritalStatus,
      this.requiredDocuments,
      this.age,
      this.minParticipant,
      this.maxParticipant,
      this.payrollArea});

  @override
  List<Object?> get props => [
        type,
        workDuration,
        dateToMatch,
        gender,
        maritalStatus,
        requiredDocuments,
        age,
        minParticipant,
        maxParticipant,
        payrollArea,
      ];
}

class BenefitApplicable extends Equatable {
  final bool? type;
  final bool? workDuration;
  final bool? dateToMatch;
  final bool? gender;
  final bool? maritalStatus;
  final bool? requiredDocuments;
  final bool? age;
  final bool? minParticipant;
  final bool? maxParticipant;
  final bool? payrollArea;

  const BenefitApplicable(
      {this.type,
      this.workDuration,
      this.dateToMatch,
      this.gender,
      this.maritalStatus,
      this.requiredDocuments,
      this.age,
      this.minParticipant,
      this.maxParticipant,
      this.payrollArea});

  @override
  List<Object?> get props => [
        type,
        workDuration,
        dateToMatch,
        gender,
        maritalStatus,
        requiredDocuments,
        age,
        minParticipant,
        maxParticipant,
        payrollArea,
      ];
}
//
// class BenefitType extends Equatable {
//   final int id;
//   final String name;
//
//   const BenefitType({required this.id, required this.name});
//
//   @override
//   List<Object?> get props => [id, name];
// }
