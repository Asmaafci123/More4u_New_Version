import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:more4u/presentation/profile/cubits/profile_cubit.dart';
import 'package:more4u/presentation/widgets/utils/loading_dialog.dart';
import 'package:more4u/presentation/widgets/utils/message_dialog.dart';
import 'dart:ui' as ui;
import '../../core/constants/app_strings.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/validators.dart';
import '../../custom_icons.dart';
import '../../domain/entities/user.dart';
import '../../injection_container.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/helpers.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/utils/app_bar.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = 'ProfileScreen';

  final User user;
  final bool? isProfile;

  const ProfileScreen({Key? key, required this.user, this.isProfile = false})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileCubit _cubit;

  @override
  void initState() {
    _cubit = sl<ProfileCubit>()..user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _cubit,
      listener: (context, state) {
        if (state is UpdatePictureLoadingState) {
          loadingAlertDialog(context);
        }
        if (state is UpdatePictureSuccessState) {
          Navigator.pop(context);
          showMessageDialog(
              context: context,
              isSucceeded: true,
              message: AppStrings.profilePictureUpdatedSuccessfully.tr(),
              onPressedOk: () {
                _cubit.clearPickedImage();
              });
        }
        if (state is UpdatePictureErrorState) {
          Navigator.pop(context);

          if(state.message==AppStrings.sessionHasBeenExpired.tr())
          {
            showMessageDialog(
                context: context, isSucceeded: false, message: state.message,
                onPressedOk: ()
                {
                  logOut(context);
                });
          }
          else
          {
            showMessageDialog(
              context: context,
              isSucceeded: false,
              message: state.message,
            );
          }

        }

        if (state is ChangePasswordLoadingState) {
          loadingAlertDialog(context);
        }
        if (state is ChangePasswordSuccessState) {
          Navigator.pop(context);
          showMessageDialog(
              context: context,
              isSucceeded: true,
              message: state.message,
              onPressedOk: () {
                logOut(context);
              });
        }
        if (state is ChangePasswordErrorState) {
          Navigator.pop(context);
          if(state.message==AppStrings.sessionHasBeenExpired.tr())
          {
            showMessageDialog(
                context: context, isSucceeded: false, message: state.message,
                onPressedOk: ()
                {
                  logOut(context);
                });
          }
          else
          {
            showMessageDialog(
              context: context,
              isSucceeded: false,
              message: state.message,
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: myAppBar(AppStrings.profile.tr()),
          resizeToAvoidBottomInset: false,
          drawer: const DrawerWidget(),
          body: SafeArea(
            child: Scrollbar(
              thumbVisibility: true,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (widget.isProfile != null && widget.isProfile!)
                          ? const MyAppBar()
                          : Container(
                              height: 50.h,
                              padding: EdgeInsets.only(top: 8.h),
                              margin: EdgeInsets.only(top: 14.h, bottom: 8.h),
                              child: IconButton(
                                splashRadius: 20.w,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                iconSize: 40.w,
                                icon: SvgPicture.asset(
                                  'assets/images/back.svg',
                                  fit: BoxFit.cover,
                                  height: 50.w,
                                  width: 50.w,
                                  clipBehavior: Clip.none,
                                  color: mainColor,
                                ),
                              ),
                            ),
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Text(
                          AppStrings.profile.tr(),
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontFamily: 'Joti',
                              color: redColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: mainColor, width: 2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                height: 130.h,
                                width: 132.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    _cubit.user!.profilePictureAPI!,
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        Image.asset(
                                            'assets/images/profile_avatar_placeholder.png',
                                            fit: BoxFit.cover),
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              if (widget.isProfile!)
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                            context: context,
                                            builder: (context) {
                                              return BlocBuilder(
                                                bloc: _cubit,
                                                builder: (context, state) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                    return Dialog(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      elevation: 0,
                                                      insetPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20.w,
                                                              vertical: 0),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Container(
                                                          width: 500.0.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.r),
                                                          ),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      12.h,
                                                                  horizontal:
                                                                      14.w),
                                                          child: Form(
                                                            key: _cubit.formKey,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      AppStrings
                                                                          .editProfile
                                                                          .tr(),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            mainColor,
                                                                        fontSize:
                                                                            20.sp,
                                                                        fontFamily:
                                                                            "Cairo",
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                    Spacer(),
                                                                    Container(
                                                                      height:
                                                                          20.h,
                                                                      width:
                                                                          20.h,
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      child: IconButton(
                                                                          padding: EdgeInsets.zero,
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          icon: Directionality(
                                                                              textDirection: ui.TextDirection.ltr,
                                                                              child: Icon(
                                                                                Icons.arrow_back_ios,
                                                                                color: mainColor,
                                                                                size: 20.r,
                                                                              ))),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Divider(),
                                                                Text(
                                                                  AppStrings
                                                                      .changeYourProfilePicture
                                                                      .tr(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        mainColor,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontFamily:
                                                                        "Cairo",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 16.h,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    _cubit
                                                                        .pickImage();
                                                                  },
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                mainColor,
                                                                            width:
                                                                                2),
                                                                        borderRadius:
                                                                            BorderRadius.circular(6.r),
                                                                      ),
                                                                      height:
                                                                          130.h,
                                                                      width:
                                                                          132.h,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6.r),
                                                                        child: _cubit.pickedImage !=
                                                                                null
                                                                            ? Image.memory(
                                                                                decodeImage(_cubit.pickedImage!),
                                                                                fit: BoxFit.cover,
                                                                                gaplessPlayback: true,
                                                                              )
                                                                            : Image.network(
                                                                                _cubit.user?.profilePictureAPI ?? '',
                                                                                errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/profile_avatar_placeholder.png', fit: BoxFit.cover),
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                if (_cubit
                                                                        .pickedImage !=
                                                                    null) ...[
                                                                  SizedBox(
                                                                    height:
                                                                        16.h,
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          55.h,
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          _cubit
                                                                              .updateProfileImage();
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          AppStrings
                                                                              .saveImage
                                                                              .tr(),
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 14.sp),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                                SizedBox(
                                                                  height: 16.h,
                                                                ),
                                                                Divider(),
                                                                Text(
                                                                  AppStrings
                                                                      .changeYourPassword
                                                                      .tr(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        mainColor,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontFamily:
                                                                        "Cairo",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 16.h,
                                                                ),
                                                                TextFormField(
                                                                    controller:
                                                                        _cubit
                                                                            .currentPasswordController,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight
                                                                            .w400,
                                                                        color:
                                                                            mainColor,
                                                                        fontSize: 12
                                                                            .sp),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      isDense:
                                                                          true,
                                                                      contentPadding:
                                                                          EdgeInsets.symmetric(
                                                                              vertical: 10.h),
                                                                      suffixIconConstraints: BoxConstraints(
                                                                          minHeight: 50
                                                                              .h,
                                                                          minWidth:
                                                                              50.w),
                                                                      prefixIconConstraints: BoxConstraints(
                                                                          minHeight: 20
                                                                              .h,
                                                                          minWidth:
                                                                              40.w),
                                                                      prefixIcon:
                                                                          Icon(
                                                                        CustomIcons
                                                                            .lock2,
                                                                        size: 20
                                                                            .r,
                                                                      ),
                                                                      suffixIcon:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        type: MaterialType
                                                                            .circle,
                                                                        clipBehavior:
                                                                            Clip.antiAlias,
                                                                        borderOnForeground:
                                                                            true,
                                                                        elevation:
                                                                            0,
                                                                        child:
                                                                            IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              _cubit.currentPassword = !_cubit.currentPassword;
                                                                            });
                                                                          },
                                                                          icon: !_cubit.currentPassword
                                                                              ? Icon(
                                                                                  Icons.visibility_off_outlined,
                                                                                  size: 30.r,
                                                                                )
                                                                              : Icon(
                                                                                  Icons.remove_red_eye_outlined,
                                                                                  size: 30.r,
                                                                                ),
                                                                        ),
                                                                      ),
                                                                      border:
                                                                          const OutlineInputBorder(),
                                                                      labelText: AppStrings
                                                                          .currentPassword
                                                                          .tr(),
                                                                      hintText: AppStrings
                                                                          .enterYourCurrentPassword
                                                                          .tr(),
                                                                      errorMaxLines:
                                                                          3,
                                                                      hintStyle: TextStyle(
                                                                          color: Color(
                                                                              0xffc1c1c1),
                                                                          fontSize:
                                                                              14.sp),
                                                                      labelStyle: TextStyle(
                                                                          color: Color(
                                                                              0xffc1c1c1),
                                                                          fontSize:
                                                                              12.sp),
                                                                      errorStyle:
                                                                          TextStyle(
                                                                              fontSize: 12.sp),
                                                                      floatingLabelBehavior:
                                                                          FloatingLabelBehavior
                                                                              .always,
                                                                    ),
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .visiblePassword,
                                                                    obscureText:
                                                                        !_cubit
                                                                            .currentPassword,
                                                                    validator:
                                                                        validatePassword),
                                                                SizedBox(
                                                                  height: 25.h,
                                                                ),
                                                                TextFormField(
                                                                    controller:
                                                                        _cubit
                                                                            .newPasswordController,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight
                                                                            .w400,
                                                                        color:
                                                                            mainColor,
                                                                        fontSize: 12
                                                                            .sp),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      isDense:
                                                                          true,
                                                                      contentPadding:
                                                                          EdgeInsets.symmetric(
                                                                              vertical: 10.h),
                                                                      suffixIconConstraints: BoxConstraints(
                                                                          minHeight: 50
                                                                              .h,
                                                                          minWidth:
                                                                              50.w),
                                                                      prefixIconConstraints: BoxConstraints(
                                                                          minHeight: 20
                                                                              .h,
                                                                          minWidth:
                                                                              40.w),
                                                                      prefixIcon:
                                                                          Icon(
                                                                        CustomIcons
                                                                            .lock2,
                                                                        size: 20
                                                                            .r,
                                                                      ),
                                                                      suffixIcon:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        type: MaterialType
                                                                            .circle,
                                                                        clipBehavior:
                                                                            Clip.antiAlias,
                                                                        borderOnForeground:
                                                                            true,
                                                                        elevation:
                                                                            0,
                                                                        child:
                                                                            IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              _cubit.newPassword = !_cubit.newPassword;
                                                                            });
                                                                          },
                                                                          icon: !_cubit.newPassword
                                                                              ? Icon(
                                                                                  Icons.visibility_off_outlined,
                                                                                  size: 30.r,
                                                                                )
                                                                              : Icon(
                                                                                  Icons.remove_red_eye_outlined,
                                                                                  size: 30.r,
                                                                                ),
                                                                        ),
                                                                      ),
                                                                      border:
                                                                          const OutlineInputBorder(),
                                                                      labelText: AppStrings
                                                                          .newPassword
                                                                          .tr(),
                                                                      hintText: AppStrings
                                                                          .enterYourNewPassword
                                                                          .tr(),
                                                                      errorMaxLines:
                                                                          3,
                                                                      hintStyle: TextStyle(
                                                                          color: Color(
                                                                              0xffc1c1c1),
                                                                          fontSize:
                                                                              14.sp),
                                                                      labelStyle: TextStyle(
                                                                          color: Color(
                                                                              0xffc1c1c1),
                                                                          fontSize:
                                                                              12.sp),
                                                                      errorStyle:
                                                                          TextStyle(
                                                                              fontSize: 12.sp),
                                                                      floatingLabelBehavior:
                                                                          FloatingLabelBehavior
                                                                              .always,
                                                                    ),
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .visiblePassword,
                                                                    obscureText:
                                                                        !_cubit
                                                                            .newPassword,
                                                                    validator:
                                                                        validatePassword),
                                                                SizedBox(
                                                                  height: 25.h,
                                                                ),
                                                                TextFormField(
                                                                    controller:
                                                                        _cubit
                                                                            .confirmNewPasswordController,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight
                                                                            .w400,
                                                                        color:
                                                                            mainColor,
                                                                        fontSize: 12
                                                                            .sp),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      isDense:
                                                                          true,
                                                                      contentPadding:
                                                                          EdgeInsets.symmetric(
                                                                              vertical: 10.h),
                                                                      suffixIconConstraints: BoxConstraints(
                                                                          minHeight: 50
                                                                              .h,
                                                                          minWidth:
                                                                              50.w),
                                                                      prefixIconConstraints: BoxConstraints(
                                                                          minHeight: 20
                                                                              .h,
                                                                          minWidth:
                                                                              40.w),
                                                                      prefixIcon:
                                                                          Icon(
                                                                        CustomIcons
                                                                            .lock2,
                                                                        size: 20
                                                                            .r,
                                                                      ),
                                                                      suffixIcon:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        type: MaterialType
                                                                            .circle,
                                                                        clipBehavior:
                                                                            Clip.antiAlias,
                                                                        borderOnForeground:
                                                                            true,
                                                                        elevation:
                                                                            0,
                                                                        child:
                                                                            IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              _cubit.confirmNewPassword = !_cubit.confirmNewPassword;
                                                                            });
                                                                          },
                                                                          icon: !_cubit.confirmNewPassword
                                                                              ? Icon(
                                                                                  Icons.visibility_off_outlined,
                                                                                  size: 30.r,
                                                                                )
                                                                              : Icon(
                                                                                  Icons.remove_red_eye_outlined,
                                                                                  size: 30.r,
                                                                                ),
                                                                        ),
                                                                      ),
                                                                      border:
                                                                          const OutlineInputBorder(),
                                                                      labelText: AppStrings
                                                                          .confirmNewPassword
                                                                          .tr(),
                                                                      hintText: AppStrings
                                                                          .reEnterYourNewPassword
                                                                          .tr(),
                                                                      errorMaxLines:
                                                                          3,
                                                                      hintStyle: TextStyle(
                                                                          color: Color(
                                                                              0xffc1c1c1),
                                                                          fontSize:
                                                                              14.sp),
                                                                      labelStyle: TextStyle(
                                                                          color: Color(
                                                                              0xffc1c1c1),
                                                                          fontSize:
                                                                              12.sp),
                                                                      errorStyle:
                                                                          TextStyle(
                                                                              fontSize: 12.sp),
                                                                      floatingLabelBehavior:
                                                                          FloatingLabelBehavior
                                                                              .always,
                                                                    ),
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .visiblePassword,
                                                                    obscureText:
                                                                        !_cubit
                                                                            .confirmNewPassword,
                                                                    validator:
                                                                        (text) {
                                                                      if (text ==
                                                                              null ||
                                                                          text
                                                                              .isEmpty) {
                                                                        return AppStrings
                                                                            .pleaseEnterPassword
                                                                            .tr();
                                                                      } else if (text !=
                                                                          _cubit
                                                                              .newPasswordController
                                                                              .text) {
                                                                        return AppStrings
                                                                            .confirmationPasswordDoesNotMatchWithNewPassword
                                                                            .tr();
                                                                      } else {
                                                                        return null;
                                                                      }
                                                                    }),
                                                                SizedBox(
                                                                  height: 16.h,
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      SizedBox(
                                                                    height:
                                                                        55.h,
                                                                    child:
                                                                        ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (_cubit
                                                                            .formKey
                                                                            .currentState!
                                                                            .validate()) {
                                                                          _cubit
                                                                              .changePassword();
                                                                        }
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        AppStrings
                                                                            .savePassword
                                                                            .tr(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: 14.sp),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 16.h,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                },
                                              );
                                            })
                                        .whenComplete(
                                            () => _cubit.clearDialog());
                                  },
                                  child: Text(
                                    AppStrings.editProfile.tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                            ],
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    _cubit.user?.userName ?? '',
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: 20.sp,
                                      fontFamily: "Cairo",
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      CustomIcons.envelope,
                                      color: mainColor,
                                    ),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment:
                                            context.locale == Locale('en')
                                                ? Alignment.centerLeft
                                                : Alignment.centerRight,
                                        child: Text(
                                          _cubit.user?.email ?? '',
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              color: greyColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      CustomIcons.briefcase,
                                      color: mainColor,
                                    ),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment:
                                            context.locale == Locale('en')
                                                ? Alignment.centerLeft
                                                : Alignment.centerRight,
                                        child: Text(
                                          _cubit.user?.positionName ?? '',
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              color: greyColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      CustomIcons.phone_call,
                                      color: mainColor,
                                    ),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    Text(
                                      _cubit.user?.phoneNumber ?? '',
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          color: greyColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      CustomIcons.fingerprint,
                                      color: mainColor,
                                    ),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    Text(
                                      _cubit.user?.userNumber.toString() ?? '',
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          color: greyColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.black26,
                      ),
                      Text(
                        AppStrings.moreInformation.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: redColor,
                          fontSize: 20.sp,
                          fontFamily: "Cairo",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            CustomIcons.cake_birthday,
                            color: mainColor,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            '${AppStrings.birthday.tr()}    ',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _cubit.user?.birthDate ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CustomIcons.venus_mars,
                            color: mainColor,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            '${AppStrings.gender.tr()}    ',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _cubit.user?.gender ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CustomIcons.clock,
                            color: mainColor,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            '${AppStrings.workDuration.tr()}   ',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _cubit.user?.workDuration ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CustomIcons.bitmap,
                            color: mainColor,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            '${AppStrings.maritalStatus.tr()}   ',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _cubit.user?.maritalStatus ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CustomIcons.apps,
                            color: mainColor,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            '${AppStrings.department.tr()}    ',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _cubit.user?.departmentName ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CustomIcons.person_solid,
                            color: mainColor,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            '${AppStrings.payrollArea.tr()}    ',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _cubit.user?.collar ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CustomIcons.seedling_solid__1_,
                            color: mainColor,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            '${AppStrings.sapNumber.tr()}    ',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _cubit.user?.sapNumber.toString() ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CustomIcons.building__1_,
                            color: mainColor,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            '${AppStrings.entity.tr()}    ',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _cubit.user?.entity ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CustomIcons.cursor_finger_1,
                            color: mainColor,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            '${AppStrings.joinedAt.tr()}    ',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _cubit.user?.joinDate ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CustomIcons.address_book,
                            color: mainColor,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            '${AppStrings.address.tr()}    ',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _cubit.user?.address ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CustomIcons.flag,
                            color: mainColor,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            '${AppStrings.nationality.tr()}    ',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _cubit.user?.nationality ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CustomIcons.cursor_finger,
                            color: mainColor,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            '${AppStrings.supervisor.tr()}    ',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _cubit.user?.supervisorName ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
