import 'package:more4u/domain/entities/participant.dart';

import '../../domain/entities/benefit_request.dart';
import '../../domain/entities/user.dart';
import 'participant_model.dart';
import 'user_model.dart';

class BenefitRequestModel extends BenefitRequest {
  const BenefitRequestModel({
    int? requestNumber,
    int? requestWorkflowId,
    String? from,
    String? to,
    String? message,
    String? groupName,
    String? selectedUserNumbers,
    List<Participant>? participantsData,
    List<User>? fullParticipantsData,
    int? sendToID,
    User? sendToModel,
    int? userNumber,
    String? requestedat,
    bool? hasDocuments,
    List<String>? documents,
    List<String>? documentsPath,
    int? benefitId,
    String? benefitName,
    String? benefitType,
    String? benefitCardAPI,
    String? status,
    int? requestStatusId,
    bool? canCancel,
    bool? canEdit,
    List<RequestWorkFlowAPIs>? requestWorkFlowAPIs,
    User? createdBy,
    String? warningMessage,
    bool? userCanResponse,
    MyAction? myAction,
    int? languageId
  }) : super(
          requestNumber: requestNumber,
          requestWorkflowId: requestWorkflowId,
          from: from,
          to: to,
          message: message,
          groupName: groupName,
          selectedUserNumbers: selectedUserNumbers,
          participantsData: participantsData,
          fullParticipantsData: fullParticipantsData,
          sendToID: sendToID,
          sendToModel: sendToModel,
          userNumber: userNumber,
          requestedat: requestedat,
          hasDocuments: hasDocuments,
          documents: documents,
    documentsPath: documentsPath,
          benefitId: benefitId,
          benefitName: benefitName,
          benefitType: benefitType,
          benefitCardAPI: benefitCardAPI,
          status: status,
          requestStatusId: requestStatusId,
          canCancel: canCancel,
          canEdit: canEdit,
          requestWorkFlowAPIs: requestWorkFlowAPIs,
          createdBy: createdBy,
          warningMessage: warningMessage,
          userCanResponse: userCanResponse,
          myAction: myAction,
    languageId: languageId
        );

  factory BenefitRequestModel.fromJson(Map<String, dynamic> json) =>
      BenefitRequestModel(
          requestNumber: json['requestNumber'],
          requestWorkflowId: json['requestWorkflowId'],
          from: json['from'],
          to: json['to'],
          message: json['message'],
          groupName: json['groupName'],
          selectedUserNumbers: json['selectedUserNumbers'],
          participantsData: json['participantsData'] != null
              ? List<Participant>.from(json['participantsData']
                  .map((x) => ParticipantModel.fromJson(x))
                  .toList())
              : null,
          fullParticipantsData: json['fullParticipantsData'] != null
              ? List<User>.from(json['fullParticipantsData']
                  .map((x) => UserModel.fromJson(x))
                  .toList())
              : null,
          sendToID: json['sendToID'],
          sendToModel: json['sendToModel'] != null
              ? UserModel.fromJson(json['sendToModel'])
              : null,
          userNumber: json['userNumber'],
          requestedat: json['requestedat'],
          hasDocuments: json['hasDocuments'],
          documents: json['documents']?.cast<String>(),
          documentsPath: json['documentsPath']?.cast<String>(),
          benefitId: json['benefitId'],
          benefitName: json['benefitName'],
          benefitType: json['benefitType'],
          benefitCardAPI: json['benefitCardAPI'],
          status: json['status'],
          requestStatusId: json['requestStatusId'],
          canCancel: json['canCancel'],
          canEdit: json['canEdit'],
          requestWorkFlowAPIs: json['requestWorkFlowAPIs'] != null
              ? List<RequestWorkFlowAPIsModel>.from(json['requestWorkFlowAPIs']
                  .map((x) => RequestWorkFlowAPIsModel.fromJson(x))
                  .toList())
              : null,
          createdBy: json['createdBy'] != null
              ? UserModel.fromJson(json['createdBy'])
              : null,
          warningMessage: json['warningMessage'],
          userCanResponse: json['userCanResponse'],
          myAction: json['myAction'] != null
              ? MyActionModel.fromJson(json['myAction'])
              : null,
        languageId: json['languageId']
      );

  Map<String, dynamic> toJson() {
    return {
      "userNumber": userNumber,
      'groupName': groupName,
      'selectedUserNumbers': selectedUserNumbers,
      "sendToID": sendToID,
      "benefitId": benefitId,
      "from": from,
      "to": to,
      "message": message,
      'documents': documents,
      "languageId":languageId
    };
  }

  factory BenefitRequestModel.fromEntity(BenefitRequest myBenefitRequest) =>
      BenefitRequestModel(
        message: myBenefitRequest.message,
        groupName: myBenefitRequest.groupName,
        selectedUserNumbers: myBenefitRequest.selectedUserNumbers,
        sendToID: myBenefitRequest.sendToID,
        benefitId: myBenefitRequest.benefitId,
        userNumber: myBenefitRequest.userNumber,
        from: myBenefitRequest.from,
        to: myBenefitRequest.to,
        documents: myBenefitRequest.documents,
        participantsData: myBenefitRequest.participantsData,
        benefitName: myBenefitRequest.benefitName,
        requestStatusId: myBenefitRequest.requestStatusId,
        canCancel: myBenefitRequest.canCancel,
        canEdit: myBenefitRequest.canEdit,
        requestWorkFlowAPIs: myBenefitRequest.requestWorkFlowAPIs,
        languageId: myBenefitRequest.languageId
      );
}

class RequestWorkFlowAPIsModel extends RequestWorkFlowAPIs {
  RequestWorkFlowAPIsModel({
    int? userNumber,
    String? userName,
    String? status,
    String? replayDate,
    String? notes,
  }) : super(
          userNumber: userNumber,
    userName: userName,
          status: status,
          replayDate: replayDate,
          notes: notes,
        );

  factory RequestWorkFlowAPIsModel.fromJson(Map<String, dynamic> json) =>
      RequestWorkFlowAPIsModel(
        userNumber: json['userNumber'],
        userName: json['userName'],
        status: json['status'],
        replayDate: json['replayDate'],
        notes: json['notes'],
      );
}

class MyActionModel extends MyAction {
  const MyActionModel({
    String? action,
    String? notes,
    String? replayDate,
    String? whoIsResponseName,
  }) : super(
          action: action,
          notes: notes,
          replayDate: replayDate,
          whoIsResponseName: whoIsResponseName,
        );

  factory MyActionModel.fromJson(Map<String, dynamic> json) => MyActionModel(
        action: json['action'],
        notes: json['notes'],
        replayDate: json['replayDate'],
        whoIsResponseName: json['whoIsResponseName'],
      );
}
