import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:more4u/core/constants/app_strings.dart';
import 'package:more4u/domain/entities/benefit_request.dart';
import 'package:more4u/domain/usecases/get_participants.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/entities/benefit.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/usecases/redeem_card.dart';

part 'redeem_state.dart';

class RedeemCubit extends Cubit<RedeemState> {
  static RedeemCubit get(context) => BlocProvider.of(context);
  final GetParticipantsUsecase getParticipantsUsecase;
  final RedeemCardUsecase redeemCardUsecase;

  RedeemCubit(
      {required this.getParticipantsUsecase, required this.redeemCardUsecase})
      : super(RedeemInitial());

  late Benefit benefit;
  List<Participant> participants = [];
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController groupName = TextEditingController();
  TextEditingController message = TextEditingController();
  late DateTime date, start, end;
  String? dateToMatch;

  late bool showParticipantsField;
  late bool enableParticipantsField = true;

  initRedeem(Benefit benefit) {

    if(benefit.requiredDocumentsArray!=null){
      myDocs = {
        for (var doc in benefit.requiredDocumentsArray!) doc: null,
      };
    }
    this.benefit = benefit;
    _configureDate(benefit);
    startDate.text = _formatDate(start);
    endDate.text = _formatDate(end);
    if (benefit.benefitType == AppStrings.group.tr() || benefit.isAgift) {
      showParticipantsField = true;
    } else {
      showParticipantsField = false;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat("yyyy-MM-dd","en_US").format(date);
  }

  _configureDate(Benefit benefit) {
    switch (benefit.dateToMatch) {
      case 'Birth Date':
        date = DateTime.parse(userData!.birthDate);
        dateToMatch =
            _formatDate(DateTime(DateTime.now().year, date.month, date.day));
        break;
      case 'join Date':
        date = DateTime.parse(userData!.joinDate);
        dateToMatch =
            _formatDate(DateTime(DateTime.now().year, date.month, date.day));
        break;
      case 'Certain Date':
        date = DateTime.parse(benefit.certainDate!);
        dateToMatch =
            _formatDate(DateTime(DateTime.now().year, date.month, date.day));
        break;
      default:
        date = DateTime.now().add(Duration(days: 1));
        break;
    }
    if(benefit.benefitType==AppStrings.group.tr()) {
      date = DateTime.now().add(Duration(days: 7));
    }
    start = DateTime(DateTime.now().year, date.month, date.day);
    end = start.add(Duration(days: benefit.numberOfDays! - 1));
    if (start.compareTo(DateTime.now()) == -1) {
      start = DateTime.now();
      end = start.add(Duration(days: benefit.numberOfDays! - 1));
    }
  }

  changeStartDate(DateTime? dateTime) {
    if (dateTime != null) {
      start = dateTime;
      end = start.add(Duration(days: benefit.numberOfDays! - 1));
      endDate.text = _formatDate(end);
      emit(DateChangeState());
    }
  }

  void getParticipants() async {
    emit(RedeemLoadingState());
    final result = await getParticipantsUsecase(
        userNumber: userData!.userNumber,
        benefitId: benefit.id,
        isGift: benefit.isAgift,
      token:accessToken,
      languageCode: languageId!
    );

    result.fold((failure) {
      emit(RedeemGetParticipantsErrorState(failure.message));
    }, (participants) {
      this.participants = participants;
      emit(RedeemGetParticipantsSuccessState());
    });
  }

  List<int> participantsIds = [];

  participantsOnChange(List<Participant> selectedParticipants) {
    if (benefit.benefitType == AppStrings.group.tr()&& selectedParticipants.length == benefit.maxParticipant-1) {
      enableParticipantsField = false;
      emit(ParticipantsChangedState());
    }
    else if (benefit.isAgift && selectedParticipants.length == benefit.maxParticipant) {
      enableParticipantsField = false;
      emit(ParticipantsChangedState());
    }
    List<int> participantsIds = [];

    for (Participant participant in selectedParticipants) {
      participantsIds.add(participant.userNumber);
    }
    this.participantsIds = participantsIds;
  }

  participantOnRemove(Participant profile) {
    participantsIds
        .removeWhere((participant) => participant == profile.userNumber);
    if (participantsIds.length < benefit.maxParticipant) {
      enableParticipantsField = true;
    }
    emit(ParticipantsChangedState());
  }

  redeemCard() async {
    if (validateParticipants()) {
      emit(RedeemLoadingState());

      List<String> documents = [];
      for (var doc in myDocs.values) {
        if (doc != null) documents.add(doc);
      }

      var request = BenefitRequest(
        selectedUserNumbers:
        benefit.benefitType == AppStrings.group.tr() ? participantsIds.join(';') : null,
        sendToID: benefit.isAgift && participantsIds.isNotEmpty
            ? participantsIds.first
            : 0,
        from: startDate.text,
        to: endDate.text,
        benefitId: benefit.id,
        userNumber: userData!.userNumber,
        groupName: groupName.text,
        message: message.text,
        documents: documents,
        languageId: languageId
      );
      final result = await redeemCardUsecase(request: request,token:accessToken);
      result.fold((failure) {
        emit(RedeemErrorState(failure.message));
      }, (success) {
        emit(RedeemSuccessState());
      });
    }
  }

  String? lowParticipantError;

  bool validateParticipants() {
    if (benefit.benefitType == AppStrings.group.tr() &&
        participantsIds.length+1 < benefit.minParticipant) {
        lowParticipantError =
            '${AppStrings.participantsShouldBeBetween.tr()} ${benefit.minParticipant} ${AppStrings.and.tr()} ${benefit.maxParticipant} ${AppStrings.includingYou.tr()}';
        emit(ErrorValidationState());
        return false;
      } else if (benefit.isAgift&&participantsIds.length < benefit.minParticipant )
      {
        lowParticipantError = AppStrings.required.tr();
        emit(ErrorValidationState());
        return false;
      }


     else {
      lowParticipantError = null;
      emit(ErrorValidationState());
    }
    return true;
  }

  String? missingDocs;

  static List<String> requiredDocs = [];

  Map<String, String?> myDocs = {
  };

  pickImage(String key) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery
            );
    if (image != null) {
      File imageFile = File(image.path);
      Uint8List bytes = imageFile.readAsBytesSync();
      String img64 = base64Encode(bytes);
      myDocs[key] = img64;
      emit(ImagePickedSuccessState());
    }
  }

  removeImage(index) {
    myDocs[myDocs.keys.elementAt(index)] = null;
    emit(ImageRemoveSuccessState());
  }

  bool validateDocuments() {
    if (benefit.requiredDocumentsArray != null) {
      for (var img in myDocs.values) {
        if (img == null) {
          missingDocs = AppStrings.missingRequiredDocs.tr();
          emit(ErrorValidationState());
          return false;
        }
      }
    } else {
      missingDocs = null;
      emit(ErrorValidationState());
    }
    return true;
  }
}
