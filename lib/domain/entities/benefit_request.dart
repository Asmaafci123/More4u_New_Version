import 'package:equatable/equatable.dart';
import 'package:more4u/domain/entities/participant.dart';
import 'package:more4u/domain/entities/user.dart';

class BenefitRequest extends Equatable {
  final int? requestNumber;
  final int? requestWorkflowId;
  final String? from;
  final String? to;
  final String? message;
  final String? groupName;
  final String? selectedUserNumbers;

  // final List<int>? participants;
  final List<Participant>? participantsData;
  final List<User>? fullParticipantsData;
  final int? sendToID;
  final User? sendToModel;
  final int? userNumber;
  final String? requestedat;
  final bool? hasDocuments;
  final List<String>? documents;
  final List<String>? documentsPath;

  //benefit data
  final int? benefitId;
  final String? benefitName;
  final String? benefitType;
  final String? benefitCardAPI;

  //my request
  final String? status;
  final int? requestStatusId;
  final bool? canCancel;
  final bool? canEdit;
  final List<RequestWorkFlowAPIs>? requestWorkFlowAPIs;

  //manage request
  final User? createdBy;
  final String? warningMessage;
  final bool? userCanResponse;
  final MyAction? myAction;

  final  int? languageId;
  const BenefitRequest({
    this.requestNumber,
    this.requestWorkflowId,
    this.from,
    this.to,
    this.message,
    this.groupName,
    this.selectedUserNumbers,
    // this.participants,
    this.participantsData,
    this.fullParticipantsData,
    this.sendToID,
    this.sendToModel,
    this.userNumber,
    this.requestedat,
    this.hasDocuments,
    this.documents,
    this.documentsPath,
    this.benefitId,
    this.benefitName,
    this.benefitType,
    this.benefitCardAPI,
    this.status,
    this.requestStatusId,
    this.canCancel,
    this.canEdit,
    this.requestWorkFlowAPIs,
    this.createdBy,
    this.warningMessage,
    this.userCanResponse,
    this.myAction,
     this.languageId
  });

  @override
  List<Object?> get props => [
        requestNumber,
        requestWorkflowId,
        from,
        to,
        message,
        groupName,
        selectedUserNumbers,
        documentsPath,
        // participants,
        participantsData,
        fullParticipantsData,
        sendToID,
        sendToModel,
        userNumber,
        requestedat,
        hasDocuments,
        documents,
        benefitId,
        benefitName,
        benefitType,
        benefitCardAPI,
        status,
        requestStatusId,
        canCancel,
        canEdit,
        requestWorkFlowAPIs,
        createdBy,
        warningMessage,
        userCanResponse,
        myAction,
    languageId
      ];

  String get statusString {
    switch (requestStatusId) {
      case 1:
        return 'Pending';
      case 2:
        return 'InProgress';
      case 3:
        return 'Approved';
      case 4:
        return 'Rejected';
      case 5:
        return 'Cancelled';
      case 6:
        return 'NotStartedYet';
      default:
        return 'Any';
    }
  }
}

class RequestWorkFlowAPIs {
  final int? userNumber;
  final String? userName;
  final String? status;
  final String? replayDate;
  final String? notes;

  RequestWorkFlowAPIs(
      {this.userNumber,
      this.userName,
      this.status,
      this.replayDate,
      this.notes});

// String get statusString {
//   switch (status) {
//     case 1:
//       return 'Pending';
//     case 2:
//       return 'InProgress';
//     case 3:
//       return 'Approved';
//     case 4:
//       return 'Rejected';
//     case 5:
//       return 'Cancelled';
//     case 6:
//       return 'NotStartedYet';
//     default:
//       return 'Any';
//   }
// }
}

class MyAction extends Equatable {
  final String? action;
  final String? notes;
  final String? replayDate;
  final String? whoIsResponseName;

  const MyAction(
      {this.action, this.notes, this.replayDate, this.whoIsResponseName});

  @override
  List<Object?> get props => [action, notes, replayDate, whoIsResponseName];
}
