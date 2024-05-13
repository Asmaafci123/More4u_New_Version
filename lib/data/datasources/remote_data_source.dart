import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:more4u/core/constants/app_strings.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:more4u/data/models/gift_model.dart';
import 'package:more4u/data/models/mobile_version_model.dart';
import 'package:more4u/data/models/profile_and_docuemnts_model.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../core/constants/api_path.dart';
import '../../domain/entities/benefit_request.dart';
import '../../domain/entities/filtered_search.dart';
import '../models/benefit_model.dart';
import '../models/benefit_request_model.dart';
import '../models/home_data_response_model.dart';
import '../models/login_response_model.dart';
import '../models/manage_requests_response_model.dart';
import '../models/medical-response-model.dart';
import '../models/noitification_model.dart';
import '../models/participant_model.dart';
import '../models/privilege_model.dart';
import '../models/user_model.dart';
import 'local_data_source/secure_local_data_source.dart';

abstract class RemoteDataSource {
  Future<LoginResponseModel> loginUser({
    required String userNumber,
    required String pass,
    required int languageCode,
  });

  Future<String> updateToken({
    required int userNumber,
    required String token,
    String? userToken,
    required int languageCode,
  });

  Future<String> getUserProfilePicture({
    required int userNumber,
    String? token,
    required int languageCode,
  });

  Future<UserModel> updateProfilePicture(
      {required int userNumber, required String photo,String? token, required int languageCode,});

  Future<String> changePassword({
    required int userNumber,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
    String? token,
    required int languageCode,
  });

  Future<BenefitModel> getBenefitDetails({required int benefitId});

  Future<List<BenefitModel>> getMyBenefits({required int userNumber,required int languageCode,String? token});

  Future<List<GiftModel>> getMyGifts(
      {String? token
        ,required int userNumber, required int requestNumber,required int languageCode});

  Future<List<PrivilegeModel>> getPrivileges(String? token);

  Future<List<BenefitRequest>> getMyBenefitRequests({
    required int userNumber,
    required int benefitId,
    int? requestNumber,
    required int languageCode,
    String? token
  });

  Future<String> cancelRequest({
    required int userNumber,
    required int benefitId,
    required int requestNumber,
    required int languageCode,
    String? token
  });

  Future<String> addResponse({
    required int userNumber,
    required int status,
    required int requestWorkflowId,
    required String message,
    required int languageCode,
    String? token
  });

  Future<ManageRequestsResponseModel> getBenefitsToManage({
    required int userNumber,
    FilteredSearch? search,
    int? requestNumber,
    String? token,
    required int languageCode
  });

  Future<ProfileAndDocumentsModel> getRequestProfileAndDocuments({
    required int userNumber,
    required int requestNumber,
    String? token,
    required int languageCode
  });

  Future<List<ParticipantModel>> getParticipants({
    required int userNumber,
    required int benefitId,
    required bool isGift,
    String? token
    ,required int languageCode
  });
  Future<void> redeemCard({required BenefitRequestModel requestModel,String?token});

  Future<List<NotificationModel>> getNotifications(
      {required int userNumber,required int languageCode,String? token});

  Future<MobileVersionModel> getLastMobileVersion();
  Future<MedicalResponseModel> getMedical(
      {String? token,required int languageCode,required String userNumber,});

  Future<String> getTermsAndConditions({required int languageCode});
  Future<void>  refreshUserToken(int? languageCode);
  Future<HomeDataResponseModel> getHomeData({
    required String userNumber,
    String? token,
    required int languageCode,
  });

}
class RemoteDataSourceImpl extends RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<BenefitModel> getBenefitDetails({required int benefitId}) {
    throw UnimplementedError();
  }

  @override
  Future<ManageRequestsResponseModel> getBenefitsToManage({
    required int userNumber,
    FilteredSearch? search,
    int? requestNumber,
    String? token,
    required int languageCode
  }) async {
    if (search != null) {
    }
    final response = search != null
        ? await client.post(Uri.parse(showRequests),
            headers: {
              'Content-Type': 'application/json',
              'Authorization':'Bearer $token',
            },
            body: jsonEncode({
              "selectedBenefitType": search.selectedBenefitType,
              "selectedRequestStatus": search.selectedRequestStatus,
              "userNumberSearch": search.userNumberSearch,
              "selectedDepartmentId": search.selectedDepartmentId,
              "selectedTimingId": search.selectedTimingId,
              "hasWarningMessage": search.hasWarningMessage,
              "searchDateFrom": search.searchDateFrom,
              "searchDateTo": search.searchDateTo,
              "selectedAll": false,
              "userNumber": userNumber,
              "languageId":languageCode
            }))
        : await client.post(
            Uri.parse(showRequestsDefault).replace(queryParameters: {
              "userNumber": userNumber.toString(),
              "requestNumber": requestNumber.toString(),
              "languageId":languageCode.toString()
            }),
            headers: {
              'Content-Type': 'application/json',
              'Authorization':'Bearer $token',
            },
          );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      ManageRequestsResponseModel manageRequestsResponseModel =
          ManageRequestsResponseModel.fromJson(result);
      return manageRequestsResponseModel;
    } else if(response.statusCode == 401)
    {
      await  refreshUserToken(languageCode);
      return getBenefitsToManage(userNumber:userNumber,search:search,requestNumber:requestNumber, token:accessToken,languageCode:languageCode);
    }
    else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }

  @override
  Future<ProfileAndDocumentsModel> getRequestProfileAndDocuments(
      {required int userNumber, required int requestNumber,String? token, required int languageCode}) async {
    final response = await client.post(
      Uri.parse(getProfilePictureAndRequestDocuments).replace(queryParameters: {
        "userNumber": userNumber.toString(),
        "requestNumber": requestNumber.toString(),
        "languageId":languageCode.toString()
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return ProfileAndDocumentsModel.fromJson(result['data']);
    } else if(response.statusCode == 401)
    {
      await  refreshUserToken(languageCode);
      return getRequestProfileAndDocuments(
          userNumber: userNumber,requestNumber:requestNumber,token:accessToken,languageCode: languageCode);
    }
    else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }
  @override
  Future<List<BenefitRequest>> getMyBenefitRequests(
      {required int userNumber,
      required int benefitId,
        required int languageCode,
      int? requestNumber,
        String? token
      }) async {
    final response = await client.post(
      Uri.parse(showMyBenefitRequests).replace(queryParameters: {
        "userNumber": userNumber.toString(),
        "BenefitId": benefitId.toString(),
        "requestNumber": requestNumber.toString(),
        "languageId":languageCode.toString()
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      List<BenefitRequestModel> myBenefitRequests = [];
      for (Map<String, dynamic> myBenefitRequest in result['data']) {
        myBenefitRequests.add(BenefitRequestModel.fromJson(myBenefitRequest));
      }
      return myBenefitRequests;
    }
    else if(response.statusCode == 401)
    {
     await  refreshUserToken(languageCode);
     return getMyBenefitRequests(userNumber: userNumber,benefitId: benefitId,languageCode: languageCode,requestNumber: requestNumber,token:accessToken);
    }else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }

  @override
  Future<List<PrivilegeModel>> getPrivileges(String? token) async {
    final response = await client.get(
      Uri.parse(getPrivilegesEndPoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      List<PrivilegeModel> privileges = [];
      for (Map<String, dynamic> privilege in result['data']) {
        privileges.add(PrivilegeModel.fromJson(privilege));
      }
      return privileges;
    }
    else if(response.statusCode == 401)
    {
      await  refreshUserToken(languageId);
      return getPrivileges(accessToken);
    }else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }
  @override
  Future<List<BenefitModel>> getMyBenefits(
      {required int userNumber,required int languageCode,String? token}) async {
    final response = await client.post(
      Uri.parse(showMyBenefits).replace(queryParameters: {
        "userNumber": userNumber.toString(),
        "languageId":languageCode.toString(),
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      List<BenefitModel> myBenefits = [];
      for (var benefit in result['data']) {
        myBenefits.add(BenefitModel.fromJson(benefit));
      }
      return myBenefits;
    } else if(response.statusCode == 401)
      {
        await  refreshUserToken(languageCode);
        return  getMyBenefits(userNumber:userNumber,languageCode:languageCode, token:accessToken);
      }
    else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }

  @override
  Future<List<GiftModel>> getMyGifts(
      {required int userNumber, int? requestNumber,String? token,required int languageCode}) async {
    final response = await client.post(
      Uri.parse(showMyGifts).replace(queryParameters: {
        "userNumber": userNumber.toString(),
        "requestNumber": requestNumber.toString(),
        "languageId":languageCode.toString(),
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      List<GiftModel> myGifts = [];
      for (var gift in result['data']) {
        myGifts.add(GiftModel.fromJson(gift));
      }
      return myGifts;
    } else if(response.statusCode == 401)
    {
      await  refreshUserToken(languageCode);
      return getMyGifts(userNumber:userNumber, requestNumber:requestNumber,token:accessToken, languageCode:languageCode);
    }
    else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }
  @override
  Future<List<NotificationModel>> getNotifications(
      {required int userNumber,required int languageCode,String? token}) async {
    Map<String, dynamic>queryParameters={
      "userNumber": userNumber.toString(),
      "languageId":languageCode.toString()
    };
    final response = await client.post(
      Uri.parse(showNotifications).replace(queryParameters:queryParameters),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      List<NotificationModel> notifications = [];
      if (result['data'] != null) {
        for (var notification in result['data']) {
          notifications.add(NotificationModel.fromJson(notification));
        }
      }
      return notifications;
    }else if(response.statusCode == 401)
    {
      await  refreshUserToken(languageCode);
      return getNotifications(userNumber:userNumber,languageCode:languageCode, token:accessToken);
    }
    else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }

  @override
  Future<List<ParticipantModel>> getParticipants(
      {required int userNumber,
      required int benefitId,
      required bool isGift,
      String?token,
        required int languageCode}) async {
    final response = await client.post(
      Uri.parse(
          isGift ? whoCanIGiveThisBenefit : whoCanRedeemThisGroupBenefit)
          .replace(queryParameters: {
        "userNumber": userNumber.toString(),
        "benefitId": benefitId.toString(),
        "languageId":languageCode.toString()
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      List<ParticipantModel> participants = [];
      for (var participant in result['data']) {
        participants.add(ParticipantModel.fromJson(participant));
      }
      return participants;
    } else if(response.statusCode == 401)
    {
      await  refreshUserToken(languageCode);
      return getParticipants(
          userNumber:userNumber,
          benefitId:benefitId,
          isGift:isGift,
          token:accessToken,
        languageCode: languageCode
      );
    }
    else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }
  @override
  Future<LoginResponseModel> loginUser(
      {required String userNumber, required String pass,required int languageCode}) async {
    final response = await client.post(Uri.parse(userLogin),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "userNumber": int.parse(userNumber),
            "password": pass,
            "rememberMe": true,
            "email": "string",
            "languageId":languageCode
          },
        ));
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      LoginResponseModel loginResponseModel =
          LoginResponseModel.fromJson(result);
      return loginResponseModel;
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }

  @override
  Future<void> redeemCard({required BenefitRequestModel requestModel,String? token}) async {

    print("*************************!!");
    print(requestModel.toJson());
    print("*************************!!");
    print(token);
    print("*************************!!");
    final response = await client.post(Uri.parse(confirmRequest),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':'Bearer $token',
        },
        body: jsonEncode(requestModel.toJson()));
    if (response.statusCode == 200) {
      return;
    }
    else if(response.statusCode == 401)
    {
      await  refreshUserToken(requestModel.languageId);
      return redeemCard( requestModel: requestModel,token:accessToken);
    }else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }

  @override
  Future<String> getUserProfilePicture({
    required int userNumber,
    String? token,
    required int languageCode,
  }) async {
    final response = await client.post(
      Uri.parse(getUserProfilePictureEndPoint).replace(
          queryParameters: {
        "userNumber": userNumber.toString(),
         "languageId":languageCode.toString()
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return result['data'];
    }
    else if(response.statusCode == 401)
    {
      await  refreshUserToken(languageCode);
      return getUserProfilePicture(userNumber: userNumber,token:accessToken,languageCode: languageCode);
    }
    else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }

  @override
  Future<String> updateToken({
    required int userNumber,
    required String token,
    String? userToken,
    required int languageCode,
  }) async {
    final response = await client.post(
      Uri.parse(mobileTokenAPI).replace(queryParameters: {
        "userNumber": userNumber.toString(),
        "newToken": token,
        "languageId":languageCode.toString()
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':'Bearer $userToken',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return result['message'];
    }
    else if(response.statusCode==401)
      {
        await  refreshUserToken(languageCode);
        return  updateToken(userNumber: userNumber,token: token,userToken: accessToken,languageCode: languageCode);
      }
    else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }

  @override
  Future<String> cancelRequest({
    required int userNumber,
    required int benefitId,
    required int requestNumber,
    required int languageCode,
    String? token
  }) async {
    final response = await client.post(
      Uri.parse(requestCancel).replace(queryParameters: {
        "userNumber": userNumber.toString(),
        "benefitId": benefitId.toString(),
        "id": requestNumber.toString(),
        "languageId":languageCode.toString()
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return result['message'];
    }
    else if(response.statusCode==401)
    {
      await  refreshUserToken(languageCode);
      return cancelRequest(userNumber:userNumber,benefitId:benefitId, requestNumber:requestNumber,languageCode:languageCode,token:accessToken);
    }
    else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }

  @override
  Future<String> addResponse({
    required int userNumber,
    required int status,
    required int requestWorkflowId,
    required String message,
    required int languageCode,
    String? token
  }) async {

    final response = await client.post(
      Uri.parse(addRequestResponse).replace(queryParameters: {
        "requestWorkflowId": requestWorkflowId.toString(),
        "status": status.toString(),
        "message": message,
        "userNumber": userNumber.toString(),
        "languageId":languageCode.toString()
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return result['message'];
    }else if(response.statusCode==401)
    {
      await  refreshUserToken(languageCode);
      return  addResponse(
          userNumber:userNumber,
          status:status,
          requestWorkflowId:requestWorkflowId,
          message:message ,
          languageCode:languageCode ,
          token:accessToken
      );
    }
    else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }

  @override
  Future<UserModel> updateProfilePicture(
      {required int userNumber, required String photo,String? token,required int languageCode,}) async {
    final response = await client.post(
      Uri.parse(updateProfilePictureEndPoint).replace(queryParameters: {
        "userNumber": userNumber.toString(),
        "languageId":languageCode.toString()
      }),
      body: jsonEncode({'photo': photo}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      UserModel user = UserModel.fromJson(result['data']);
      return user;
    }else if(response.statusCode==401)
    {
      await  refreshUserToken(languageCode);
      return  updateProfilePicture(userNumber:userNumber,photo:photo,token:accessToken,languageCode: languageCode
      );
    }
    else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      }else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }

  @override
  Future<String> changePassword(
      {required int userNumber,
      required String oldPassword,
      required String newPassword,
      required String confirmPassword,
        String? token,
        required int languageCode,
      }) async {
    final response = await client.post(
      Uri.parse(changePasswordEndPoint),
      body: jsonEncode({
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
        "userNumber": userNumber,
        "languageId":languageCode
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return result['message'];
    }else if(response.statusCode==401)
    {
      await  refreshUserToken(languageCode);
      return changePassword(
          userNumber:userNumber,
           oldPassword:oldPassword,
          newPassword:newPassword,
         confirmPassword:confirmPassword,
           token:accessToken,
        languageCode: languageCode
      );
    }
    else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }

  @override
  Future<MobileVersionModel> getLastMobileVersion() async {
    final response = await client.get(
      Uri.parse(getLastMobileVersionAPI),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      MobileVersionModel mobileVersionModel = MobileVersionModel.fromJson(result);
      return mobileVersionModel;
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }

  }

  @override
  Future<MedicalResponseModel> getMedical(
      {String? token,required int languageCode ,required String userNumber,}) async {
    final response = await client.post(
      Uri.parse(getMedicalEndPoint),
      body: jsonEncode({
        "languageId":languageCode.toString(),
        "userNumber":userNumber
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return MedicalResponseModel.fromJson(result);
    } else if(response.statusCode == 401)
    {
      await  refreshUserToken(languageCode);
      return getMedical(token: accessToken,languageCode: languageCode,userNumber: userNumber);
    }
    else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }

  @override
  Future<String> getTermsAndConditions({required int languageCode})async {
    final response = await client.get(
      Uri.parse(getTermsAndConditionsEndPoint).replace(queryParameters: {
        "languageId":languageCode.toString()
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return result['data']['text'];
    }
    else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }

  @override
  Future<void> refreshUserToken(int? languageCode)async {
    final response = await client.post(
      Uri.parse(refreshTokenAPI).replace(
          queryParameters: {
        "languageId":languageCode.toString()
      }),
      body: jsonEncode({
        "accessToken": accessToken,
        "refreshToken": refreshToken
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      final secureStorage=SecureStorageImpl();
      secureStorage.deleteSecureData('user accessToken');
      secureStorage.writeSecureData('user accessToken',result['data']['accessToken']);
      accessToken=await secureStorage.readSecureData('user accessToken');
      refreshToken=await secureStorage.readSecureData('user refreshToken');
    }
    else if(response.statusCode ==401)
      {
        Map<String, dynamic> result = jsonDecode(response.body);
        if (result.isNotEmpty && result['message'] != null) {
          throw ServerException(result['message']);
        } else {
          throw ServerException(AppStrings.someThingWentWrong.tr());
        }
      }
    else {
      throw ServerException(AppStrings.someThingWentWrong.tr());
    }
  }

  @override
  Future<HomeDataResponseModel> getHomeData({
    required String userNumber,
    String? token,
    required int languageCode,
  }) async {

    final response = await client.post(Uri.parse(getHomeDataEndPoint).replace(
        queryParameters: {
          "languageId":languageCode.toString(),
          "userNumber":userNumber
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':'Bearer $token',
        },
        );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      HomeDataResponseModel homeDataResponseModel =
      HomeDataResponseModel.fromJson(result);
      return homeDataResponseModel;
    }else if(response.statusCode==401)
    {
      await  refreshUserToken(languageCode);
      return getHomeData(
       userNumber:userNumber,
        token:accessToken,
         languageCode:languageCode,
      );
    }
    else {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException(AppStrings.someThingWentWrong.tr());
      }
    }
  }
}


