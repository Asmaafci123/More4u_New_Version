import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import '../../../core/constants/constants.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/changePassword.dart';
import '../../../domain/usecases/get_employee_profile_picture.dart';
import '../../../domain/usecases/updateProfilePicture.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  static ProfileCubit get(context) => BlocProvider.of(context);

  UpdateProfilePictureUsecase updateProfilePictureUsecase;
  ChangePasswordUsecase changePasswordUsecase;
  GetUserProfilePictureUsecase getUserProfilePictureUsecase;

  ProfileCubit({
    required this.updateProfilePictureUsecase,
    required this.changePasswordUsecase,
    required this.getUserProfilePictureUsecase,
  }) : super(ProfileInitial());

  User? user;
  String? pickedImage;

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery
            );
    if (image != null) {
      File imageFile = File(image.path);
      Uint8List bytes = imageFile.readAsBytesSync();

      String img64 = base64Encode(bytes);
      pickedImage = img64;

      emit(ImagePickedSuccessState());
    }
  }
  updateProfileImage() async {
    emit(UpdatePictureLoadingState());
    final result = await updateProfilePictureUsecase(
        userNumber: userData!.userNumber, photo: pickedImage!,token:accessToken,languageCode: languageId!);
    result.fold((failure) {
      emit(UpdatePictureErrorState(failure.message));
    }, (user) {
      userData = user;
      this.user = user;
      emit(UpdatePictureSuccessState());
    });
  }

  void clearPickedImage() {
    pickedImage = null;
    emit(ProfileInitial());
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool currentPassword = false, newPassword = false, confirmNewPassword = false;
  TextEditingController currentPasswordController = TextEditingController(),
      newPasswordController = TextEditingController(),
      confirmNewPasswordController = TextEditingController();

  changePassword() async {
    emit(ChangePasswordLoadingState());
    final result = await changePasswordUsecase(
        userNumber: userData!.userNumber,
        oldPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        confirmPassword: confirmNewPasswordController.text,
        token:accessToken,
      languageCode:languageId!,
    );
    result.fold((failure) {
      emit(ChangePasswordErrorState(failure.message));
    }, (message) {
      emit(ChangePasswordSuccessState(message));
    });
  }

  void clearDialog() {
    currentPassword = false;
    newPassword = false;
    confirmNewPassword = false;
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();
    pickedImage = null;
    emit(ProfileInitial());
  }
}
