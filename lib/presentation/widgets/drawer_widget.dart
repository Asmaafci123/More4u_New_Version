import 'dart:async';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart' as bg;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:more4u/core/constants/app_strings.dart';
import 'package:more4u/custom_icons.dart';
import 'package:more4u/presentation/home/home_screen.dart';
import 'package:more4u/presentation/manage_requests/manage_requests_screen.dart';
import 'package:more4u/presentation/my_benefits/my_benefits_screen.dart';
import 'package:more4u/presentation/profile/profile_screen.dart';
import 'package:more4u/presentation/terms_and_conditions/terms_and_conditions.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../core/constants/constants.dart';
import '../home/cubits/home_cubit.dart';
import '../my_gifts/my_gifts_screen.dart';
import '../notification/notification_screen.dart';
import 'helpers.dart';
import 'powered_by_cemex.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _cubit = HomeCubit.get(context);
    final completer = Completer();
    return SafeArea(
      child: SizedBox(
        width: 273.w,
        child: Drawer(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                color: Colors.white.withOpacity(0.8),
                padding:
                EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.h),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(flex: 3),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: mainColor, width: 2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          height: 130.h,
                          width: 132.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              userData!.profilePictureAPI!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                      cacheHeight: 181,
                                      cacheWidth: 184,
                                      'assets/images/profile_avatar_placeholder.png',
                                      fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        const Spacer(flex: 2,),
                        Container(
                          height: 35.h,
                          width: 35.h,
                          padding: EdgeInsets.zero,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: SvgPicture.asset(
                              'assets/images/close.svg',
                              height: 30.h,
                              width: 30.h,
                              color: mainColor,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Image.asset('assets/images/banner.png', height: 66.h),
                          Container(
                            alignment: Alignment.center,
                            width: 170.w,
                            height: 53.h,
                            child: AutoSizeText(
                              userData!.userName ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              wrapWords: false,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.0.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                    buildListTile(
                      context,
                      title: 'Home'.tr(),
                      leading: CustomIcons.home__2_,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.popUntil(
                            context, ModalRoute.withName(HomeScreen.routeName));
                      },
                    ),
                    buildListTile(
                      context,
                      title: 'My Requests'.tr(),
                      leading: CustomIcons.ticket,
                      onTap: () async {
                        Navigator.pop(context);
                        if (ModalRoute //send argument to widget
                            .of(context)
                            ?.settings
                            .name ==
                            HomeScreen.routeName) {
                          final completer = Completer();
                          final result = await Navigator.pushNamed(
                              context, MyBenefitsScreen.routeName)
                              .whenComplete(() {
                            _cubit.getHomeData();
                          });
                          completer.complete(result);
                        } else {
                          final result = await Navigator.pushReplacementNamed(
                              context, MyBenefitsScreen.routeName,
                              result: completer.future);
                          completer.complete(result);
                        }
                      },
                    ),
                    buildListTile(
                      context,
                      title: AppStrings.myGifts.tr(),
                      leading: CustomIcons.balloons,
                      onTap: () async {
                        Navigator.pop(context);

                        if (ModalRoute.of(context)?.settings.name ==
                            HomeScreen.routeName) {
                          final completer = Completer();
                          final result = await Navigator.pushNamed(
                              context, MyGiftsScreen.routeName)
                              .whenComplete(() {
                            _cubit.getHomeData();
                          });
                          completer.complete(result);
                        } else {
                          final result = await Navigator.pushReplacementNamed(
                              context, MyGiftsScreen.routeName,
                              result: completer.future);
                          completer.complete(result);
                        }
                      },
                    ),
                    buildListTile(
                      context,
                      title: AppStrings.notifications.tr(),
                      leading: CustomIcons.bell,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            NotificationScreen.routeName,
                            ModalRoute.withName(HomeScreen.routeName))
                            .whenComplete(() => _cubit.getHomeData());
                      },
                    ),
                    buildListTile(
                      context,
                      title:AppStrings.profile.tr(),
                      leading: CustomIcons.user,
                      onTap: () async {
                        Navigator.pop(context);
                        if (ModalRoute.of(context)?.settings.name ==
                            HomeScreen.routeName) {
                          Navigator.pushNamed(context, ProfileScreen.routeName,
                              arguments: {
                                'user': userData,
                                'isProfile': true
                              }).whenComplete(() => _cubit.getHomeData());
                        } else {
                          final result = await Navigator.pushReplacementNamed(
                              context, ProfileScreen.routeName,
                              arguments: {
                                'user': userData,
                                'isProfile': true,
                              },
                              result: completer.future);
                          completer.complete(result);
                        }
                      },
                    ),
                    buildListTile(
                      context,
                      title: AppStrings.termsAndConditions.tr(),
                      leading: CustomIcons.document,
                        onTap: () async {
                          Navigator.pop(context);
                          if (ModalRoute.of(context)?.settings.name ==
                              HomeScreen.routeName) {
                            final completer = Completer();
                            final result = await Navigator.pushNamed(
                                context, TermsAndConditions.routeName,arguments: false)
                                .whenComplete(() {
                              _cubit.getHomeData();
                            });
                            completer.complete(result);
                          } else {
                            final result = await Navigator.pushReplacementNamed(
                                context, TermsAndConditions.routeName,arguments: false,
                                result: completer.future);
                            completer.complete(result);
                          }
                        }
                    ),
                    Divider(),
                    if (userData!.hasRoles! || userData!.hasRequests!)
                      buildListTile(
                        context,
                        title: AppStrings.manageRequests.tr(),
                        leading: CustomIcons.business_time,
                        onTap: () async {
                          Navigator.pop(context);
                          if (ModalRoute.of(context)?.settings.name ==
                              HomeScreen.routeName) {
                            Navigator.pushNamed(
                                context, ManageRequestsScreen.routeName)
                                .whenComplete(() => _cubit.getHomeData());
                          } else {
                            final result = await Navigator.pushReplacementNamed(
                                context, ManageRequestsScreen.routeName,
                                result: completer.future);
                            completer.complete(result);
                          }
                        },
                      ),
                    buildListTile(
                      context,
                      title: 'Logout'.tr(),
                      leading: CustomIcons.sign_out_alt,
                      onTap: () {
                        Navigator.pop(context);
                        logOut(context);
                      },
                    ),
                    Spacer(),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: PoweredByCemex()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListTile(BuildContext context,
      {required IconData leading,
        required String title,
        void Function()? onTap}) {
    return SizedBox(
      height: 50.h,
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        child: ListTile(
          dense: true,
          minLeadingWidth: 0,
          minVerticalPadding: 0,
          contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
          leading: title == AppStrings.manageRequests.tr()
              ? BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return bg.Badge(
                showBadge:
                HomeCubit.get(context).pendingRequestsCount != 0,
                ignorePointer: true,
                position: bg.BadgePosition.bottomEnd(),
                badgeColor: redColor,
                padding: EdgeInsets.all(0),
                badgeContent: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  height: 20.h,
                  width: 20.w,
                  child: AutoSizeText(
                    HomeCubit.get(context).pendingRequestsCount > 99
                        ? '+99'
                        : HomeCubit.get(context)
                        .pendingRequestsCount
                        .toString(),
                    maxLines: 1,
                    wrapWords: false,
                    textAlign: TextAlign.center,
                    minFontSize: 9,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                child: SimpleShadow(
                  offset: const Offset(0, 4),
                  color: Colors.black,
                  child: Icon(leading, color: mainColor, size: 25.r),
                ),
              );
            },
          )
              : SimpleShadow(
            offset: const Offset(0, 4),
            color: Colors.black,
            child: Icon(leading, color: mainColor, size: 25.r),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: greyColor,
              fontWeight: FontWeight.w700,
              fontSize: 16.0.sp,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
