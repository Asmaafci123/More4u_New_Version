import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:more4u/core/constants/app_strings.dart';
import 'package:more4u/custom_icons.dart';
import 'package:more4u/presentation/manage_requests/manage_requests_screen.dart';
import 'package:more4u/presentation/my_gifts/my_gifts_screen.dart';
import 'package:more4u/presentation/widgets/drawer_widget.dart';
import 'package:more4u/presentation/widgets/utils/message_dialog.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/constants/constants.dart';
import '../home/cubits/home_cubit.dart';
import '../my_benefit_requests/my_benefit_requests_screen.dart';
import '../widgets/helpers.dart';
import '../widgets/utils/app_bar.dart';
import 'cubits/notification_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = 'NotificationScreen';

  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationCubit _cubit;

  @override
  void initState() {
    _cubit = NotificationCubit.get(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (context.locale.languageCode == 'ar') {
      timeago.setLocaleMessages('ar', ArMessages());
    }
    return BlocConsumer(
      bloc: _cubit,
      listener: (context, state) {
        if (state is GetNotificationsLoadingState) {
        }
        if (state is GetNotificationsSuccessState) {
          HomeCubit.get(context).changeNotificationCount(0);
        }
        if (state is GetNotificationsErrorState) {
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
                context: context, isSucceeded: false, message: state.message);
          }

        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: myAppBar(AppStrings.notifications.tr()),
          drawer: const DrawerWidget(),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(builder: (context) {
                    return Material(
                      borderRadius: BorderRadius.circular(100),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        iconSize: 45.w,
                        icon: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/images/cadeau.png'),
                            Padding(
                              padding: EdgeInsets.only(top: 24.0.h),
                              child: SvgPicture.asset(
                                'assets/images/menu.svg',
                                // fit: BoxFit.cover,
                                width: 25.h,
                                height: 25.h,
                                color: mainColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    AppStrings.notifications.tr(),
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Joti',
                        color: mainColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  if (state is GetNotificationsLoadingState)
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                          child: LinearProgressIndicator(
                        minHeight: 2.h,
                        backgroundColor: mainColor.withOpacity(0.4),
                      )),
                    ),
                  Expanded(
                    child: _cubit.notifications.isNotEmpty
                        ? AnimationLimiter(
                            child: RefreshIndicator(
                              triggerMode: RefreshIndicatorTriggerMode.anywhere,
                              onRefresh: () async {
                                _cubit.getNotifications();
                              },
                              child: ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider();
                                },
                                itemCount: _cubit.notifications.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    child: SlideAnimation(
                                      horizontalOffset: 100.0,
                                      child: FadeInAnimation(
                                        child: Material(
                                          // borderRadius: BorderRadius.circular(16.0.r),
                                          elevation: 0,
                                          child: InkWell(
                                            onTap: () async {
                                              if (_cubit.notifications[index]
                                                          .notificationType ==
                                                      'Request' ||
                                                  _cubit.notifications[index]
                                                          .notificationType ==
                                                      'Take Action') {
                                                final completer = Completer();
                                                final result = await Navigator
                                                    .pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ManageRequestsScreen(
                                                            requestNumber: _cubit
                                                                .notifications[
                                                                    index]
                                                                .requestNumber!,
                                                          ),
                                                        ),
                                                        result:
                                                            completer.future);
                                                completer.complete(result);
                                              } else if (_cubit
                                                      .notifications[index]
                                                      .notificationType ==
                                                  'Gift') {
                                                final completer = Completer();
                                                final result = await Navigator
                                                    .pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyGiftsScreen(
                                                            requestNumber: _cubit
                                                                .notifications[
                                                                    index]
                                                                .requestNumber!,
                                                          ),
                                                        ),
                                                        result:
                                                            completer.future);
                                                completer.complete(result);
                                              } else {
                                                final completer = Completer();
                                                final result = await Navigator
                                                    .pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyBenefitRequestsScreen(
                                                            benefitID: _cubit
                                                                .notifications[
                                                                    index]
                                                                .benefitId!,
                                                            requestNumber: _cubit
                                                                .notifications[
                                                                    index]
                                                                .requestNumber!,
                                                          ),
                                                        ),
                                                        result:
                                                            completer.future);
                                                completer.complete(result);
                                              }
                                            },
                                            child: Row(children: [
                                              CircleAvatar(
                                                  radius: 24.w,
                                                  backgroundColor: mainColor,
                                                  child: Icon(
                                                    _cubit.notifications[index]
                                                                    .notificationType ==
                                                                'Request' ||
                                                            _cubit
                                                                    .notifications[
                                                                        index]
                                                                    .notificationType ==
                                                                'Take Action'
                                                        ? Icons.task_outlined
                                                        : _cubit
                                                                    .notifications[
                                                                        index]
                                                                    .notificationType ==
                                                                'Response'
                                                            ? Icons
                                                                .call_received
                                                            : _cubit
                                                                        .notifications[
                                                                            index]
                                                                        .notificationType ==
                                                                    'Gift'
                                                                ? CustomIcons
                                                                    .balloons
                                                                : Icons
                                                                    .groups_outlined,
                                                    size: 30.w,
                                                    color: Colors.white,
                                                  )),
                                              SizedBox(width: 16.w),
                                              Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        _cubit
                                                                .notifications[
                                                                    index]
                                                                .userFullName ??
                                                            '',
                                                        style: TextStyle(
                                                            color: mainColor,
                                                            fontSize: 13.sp,
                                                            fontFamily:
                                                                "Roboto",
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        _cubit
                                                                .notifications[
                                                                    index]
                                                                .message ??
                                                            '',
                                                        style: TextStyle(
                                                          color: greyColor,
                                                          fontSize: 13.sp,
                                                          fontFamily: "Roboto",
                                                        ),
                                                      ),
                                                      Text(
                                                        _cubit
                                                                .notifications[
                                                                    index]
                                                                .requestNumber
                                                                .toString() ??
                                                            '',
                                                        style: TextStyle(
                                                          color: greyColor,
                                                          fontSize: 13.sp,
                                                          fontFamily: "Roboto",
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons.alarm,
                                                              size: 22.r,
                                                            ),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                            Text(
                                                                timeago.format(
                                                                DateTime.parse(_cubit
                                                                    .notifications[
                                                                        index]
                                                                    .date!),
                                                                locale: context
                                                                    .locale
                                                                    .languageCode),
                                                            style: TextStyle(
                                                              fontSize: 10.sp
                                                            ),)
                                                          ],
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : state is GetNotificationsLoadingState
                            ? Center(child: CircularProgressIndicator())
                            : RefreshIndicator(
                                triggerMode:
                                    RefreshIndicatorTriggerMode.anywhere,
                                onRefresh: () async {
                                  _cubit.getNotifications();
                                },
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return SingleChildScrollView(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: constraints.maxHeight,
                                        child: Center(
                                          child: Text(
                                            AppStrings.thereIsNoNotification
                                                .tr(),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: greyColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
