import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:more4u/domain/entities/benefit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/datasources/local_data_source/secure_local_data_source.dart';
import '../../../data/models/category-model.dart';
import '../../../data/models/details-of-medical-model.dart';
import '../../../domain/entities/privilege.dart';
import '../../../domain/usecases/get-medical.dart';
import '../../../domain/usecases/get_home_data.dart';
import '../../../domain/usecases/get_privileges.dart';
import '../../../data/datasources/local_data_source/local_data_source.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetPrivilegesUsecase getPrivilegesUsecase;
  final GetMedicalUsecase getMedicalUsecase;
  final  HomeDataUseCase homeData;

  static HomeCubit get(context) => BlocProvider.of(context);

  HomeCubit({required this.homeData, required this.getPrivilegesUsecase,required this.getMedicalUsecase})
      : super(HomeInitial());

  List<Benefit> benefitModels = [];
  List<Benefit>? availableBenefitModels = [];
  List<Privilege> privileges = [];
  List<String> medical = ['Clinics','Hospitals','Pharmacies','Radiology centers','Optometry centers','Laboratories'];
  List<String> clinics = ['Eye','Bones','Teeth','Surgery'];
  List<String> iconOfClinics = ['eye','bones','teeth','surgery'];
  List<String> iconOfMedical =['Clinics','Hospitals','Pharmacies','Radiology centers','Optometry centers','Laboratories'];
  String? user;
  int userUnSeenNotificationCount = 0;
  int pendingRequestsCount = 0;
  int priviligesCount = 0;

 getHomeData() async {
    emit(GetHomeDataLoadingState());
    await _getUserData();
    await _getLanguageCode();
    var json = jsonDecode(user!);
    final result = await homeData(
        userNumber: json['userNumber'], token: accessToken,languageCode:languageId!);
    result.fold((failure) {
      emit(GetHomeDataErrorState(failure.message));
    }, (homeDataResponse) {
      userData = homeDataResponse.user;
      benefitModels = homeDataResponse.benefitModels;
      availableBenefitModels = homeDataResponse.availableBenefitModels;
      userUnSeenNotificationCount = homeDataResponse.userUnSeenNotificationCount;
      pendingRequestsCount =homeDataResponse.user.pendingRequestsCount!;
      priviligesCount = homeDataResponse.priviligesCount;
      emit(GetHomeDataSuccessState());
    });
  }

  void changeNotificationCount(int count) {
    userUnSeenNotificationCount = count;
    emit(NotificationCountChangeState());
  }
  void changePendingRequestsCount(int count) {
    pendingRequestsCount = count;
    emit(NotificationCountChangeState());
  }

  _getUserData() async {
    final secureStorage=SecureStorageImpl();
    String? userId=await secureStorage.readSecureData('user id');
    accessToken=await secureStorage.readSecureData('user accessToken');
    refreshToken=await secureStorage.readSecureData('user refreshToken');
    Map<String,dynamic> savedUser = {
      'userNumber':userId,
      'accessToken':accessToken,
      'refreshToken':refreshToken,
    };
    final String cachedUser=jsonEncode(savedUser);
    user = cachedUser;
  }
  _getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    final int? languageCode=prefs.getInt(APP_LANGUAGE);
    languageId = languageCode??1;
  }

  Future<void> getPrivileges() async {
    if (privileges.isEmpty) {
    emit(GetPrivilegesLoadingState());
      final result = await getPrivilegesUsecase(accessToken);
      result.fold((failure) {
        emit(GetPrivilegesErrorState(failure.message));
      }, (privileges) {
        this.privileges = privileges;
        emit(GetPrivilegesSuccessState());
      });
    }
  }

  List<CategoryModel>cat=[];
  List<CategoryModel>subCat=[];
  List<DetailsOfMedicalModel>detailsOfMedical=[];
  Future<void> getMedical() async {
    await _getUserData();
    await _getLanguageCode();
    var json = jsonDecode(user!);
      emit(GetMedicalLoadingState());
      final result = await getMedicalUsecase(
          token:accessToken,languageCode: languageId!,userNumber: json['userNumber']);
      result.fold((failure) {
        emit(GetMedicalErrorState(failure.message));
      }, (response) {
        cat=List<CategoryModel>.from(response.category!);
        subCat=List<CategoryModel>.from(response.subCategory!);
        detailsOfMedical=List<DetailsOfMedicalModel>.from(response.medicalDetails!);
        emit(GetMedicalSuccessState());
      });
  }
  List<CategoryModel>subCategory=[];
  List<CategoryModel> getSubCategory(String searchCategory)
  {
    subCategory=[];
    for(var category in subCat)
      {
        if(searchCategory==category.categoryName) {
          subCategory.add(category);
        }
      }
    return subCategory;
  }

  List<DetailsOfMedicalModel>details=[];
  List<DetailsOfMedicalModel> getDetailsOfMedical(String searchCategory,String searchSubCategory)
  {
    details=[];
    for(var category in detailsOfMedical)
    {
      if(searchCategory==category.categoryName && searchSubCategory==category.subCategoryName) {
        details.add(category);
      }
    }
    return details;
  }
  List<DetailsOfMedicalModel> resultList=[];
  searchInMedical(List<DetailsOfMedicalModel> medicalList,String input)
  {
    resultList=[];
    for(var element in medicalList)
    {
      String text1=element.medicalDetailsName!.toLowerCase();
      String text2=input.toLowerCase();
      if(text1.isNotEmpty && text1.contains(text2))
        {
          resultList.add(element);
        }
    }
    emit(SearchInMedicalSuccessState());
  }

  TextEditingController searchMedicalController = TextEditingController();
  void clearSearchController()
  {
    searchMedicalController.clear();
  }
}
