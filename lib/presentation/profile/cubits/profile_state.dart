part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ImagePickedSuccessState extends ProfileState {}

class UpdatePictureLoadingState extends ProfileState {}

class UpdatePictureSuccessState extends ProfileState {}

class UpdatePictureErrorState extends ProfileState {
  final String? message;

  UpdatePictureErrorState(this.message);
}


class GetProfilePictureLoadingState extends ProfileState {}

class GetProfilePictureSuccessState extends ProfileState {}

class GetProfilePictureErrorState extends ProfileState {
  final String? message;

  GetProfilePictureErrorState(this.message);
}

  class ChangePasswordLoadingState extends ProfileState {}

  class  ChangePasswordSuccessState extends ProfileState {
    final String? message;
    ChangePasswordSuccessState(this.message);
  }

  class  ChangePasswordErrorState extends ProfileState {
  final String? message;
  ChangePasswordErrorState(this.message);

  }