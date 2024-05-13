import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more4u/core/constants/app_strings.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';
import 'package:timeago/timeago.dart';

import '../../core/constants/constants.dart';
import '../../core/firebase/push_notification_service.dart';
import '../widgets/benifit_card.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/helpers.dart';
import '../widgets/medical_widget.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/privilege_card.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../widgets/utils/loading_dialog.dart';
import '../widgets/utils/message_dialog.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await HomeCubit.get(context).getHomeData();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        HomeCubit.get(context);
      }
    }
  }

  @override
  void didChangeDependencies() {
    SystemChannels.lifecycle.setMessageHandler((msg) async{
      if(msg == AppLifecycleState.resumed.toString()) {
        await HomeCubit.get(context).getHomeData();
      }
      return Future.delayed(Duration.zero);
    });
    PushNotificationService.init(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    var _cubit = HomeCubit.get(context);
    _cubit.getMedical();
    if (context.locale.languageCode == 'ar') {
      timeago.setLocaleMessages('ar', ArMessages());
    }
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if(state is GetHomeDataLoadingState)
        {
          loadingAlertDialog(context);
        }
        if (state is GetHomeDataSuccessState) {
          Navigator.pop(context);
        }
        if(state is GetHomeDataErrorState)
        {
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
              onPressedOk: () => Navigator.pop(context),
            );
          }
        }
        if(state is GetPrivilegesErrorState)
          {
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
                onPressedOk: () => Navigator.pop(context),
              );
            }
          }
        if(state is GetMedicalErrorState)
        {
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
              onPressedOk: () => Navigator.pop(context),
            );
          }
        }

      },
      builder: (context, state) {
        return Scaffold(
          drawer: const DrawerWidget(),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MyAppBar(),
                  Padding(
                    padding: EdgeInsets.only(right: 50.w),
                    child: AutoSizeText(
                      userData?.userName ?? '',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 24.sp,
                          fontFamily: 'Joti',
                          color: mainColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    'Chose your benefit card'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: greyColor,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Theme(
                    data: ThemeData(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                    child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        unselectedLabelColor: Color(0xFF6D6D6D),
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorPadding: EdgeInsets.symmetric(vertical: 20.h),
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: redColor),
                        padding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.symmetric(vertical: 0.h),
                        onTap: (index) {
                          if (index == 2) {
                            _cubit.getMedical();
                          }
                        },
                        tabs: [
                          Tab(
                            height: 75.h,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "${AppStrings.allCards.tr()} (${_cubit.benefitModels.length})",
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            height: 75.h,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                    style: TextStyle(fontSize: 12.sp),
                                    "${"Available".tr()} (${_cubit.availableBenefitModels?.length ?? '0'})"),
                              ),
                            ),
                          ),
                          Tab(
                            height: 75.h,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                    style: TextStyle(fontSize: 12.sp),
                                    "${"Medical".tr()} (${_cubit.cat.length})"),
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.h, bottom: 16.h, left: 8.w, right: 8.w),
                    child: Center(
                      child: state is GetHomeDataLoadingState
                          ? LinearProgressIndicator(
                              minHeight: 2.h,
                              backgroundColor: mainColor.withOpacity(0.4),
                            )
                          : SizedBox(
                              height: 2.h,
                            ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          RefreshIndicator(
                            triggerMode: RefreshIndicatorTriggerMode.anywhere,
                            onRefresh: () async {
                              HomeCubit.get(context).getHomeData();
                            },
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return BenefitCard(
                                    benefit: _cubit.benefitModels[index]);
                              },
                              itemCount: _cubit.benefitModels.length,
                            ),
                          ),
                          _cubit.availableBenefitModels != null &&
                                  _cubit.availableBenefitModels?.length != 0
                              ? RefreshIndicator(
                                  triggerMode:
                                      RefreshIndicatorTriggerMode.anywhere,
                                  onRefresh: () async {
                                    HomeCubit.get(context).getHomeData();
                                  },
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) =>
                                        BenefitCard(
                                            benefit:
                                                _cubit.availableBenefitModels![
                                                    index]),
                                    itemCount:
                                        _cubit.availableBenefitModels?.length,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                  AppStrings.noBenefitAvailable.tr(),
                                  style: TextStyle(fontSize: 12.sp),
                                )),
                          // _cubit.privileges.isNotEmpty
                          //     ? RefreshIndicator(
                          //         triggerMode:
                          //             RefreshIndicatorTriggerMode.anywhere,
                          //         onRefresh: () async {
                          //           HomeCubit.get(context).getHomeData();
                          //         },
                          //         child: ListView.builder(
                          //           padding: EdgeInsets.zero,
                          //           itemBuilder: (context, index) =>
                          //               PrivilegeCard(
                          //                   privilege:
                          //                       _cubit.privileges[index]),
                          //           itemCount: _cubit.privileges.length,
                          //         ),
                          //       )
                          //     : BlocBuilder<HomeCubit, HomeState>(
                          //         builder: (context, state) {
                          //           return Container(
                          //             child: state is GetPrivilegesLoadingState
                          //                 ? Center(
                          //                     child:
                          //                         CircularProgressIndicator())
                          //                 : RefreshIndicator(
                          //                     triggerMode:
                          //                         RefreshIndicatorTriggerMode
                          //                             .anywhere,
                          //                     onRefresh: () async {
                          //                       HomeCubit.get(context)
                          //                           .getHomeData();
                          //                     },
                          //                     child: LayoutBuilder(builder:
                          //                         (context, constraints) {
                          //                       return SingleChildScrollView(
                          //                         physics:
                          //                             AlwaysScrollableScrollPhysics(),
                          //                         child: Container(
                          //                             alignment:
                          //                                 Alignment.center,
                          //                             height:
                          //                                 constraints.maxHeight,
                          //                             child: Text(
                          //                                 style: TextStyle(
                          //                                     fontSize: 13.sp),
                          //                                 AppStrings
                          //                                     .noPrivilegesAvailable
                          //                                     .tr())),
                          //                       );
                          //                     }),
                          //                   ),
                          //           );
                          //         },
                          //       ),
                          _cubit.cat.isNotEmpty
                              ? RefreshIndicator(
                                  triggerMode:
                                      RefreshIndicatorTriggerMode.anywhere,
                                  onRefresh: () async {
                                    HomeCubit.get(context).getMedical();
                                  },
                                  child: const MedicalWidget(),
                                )
                              : BlocBuilder<HomeCubit, HomeState>(
                                  builder: (context, state) {
                                    return Container(
                                      child: state is GetMedicalLoadingState
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : RefreshIndicator(
                                              triggerMode:
                                                  RefreshIndicatorTriggerMode
                                                      .anywhere,
                                              onRefresh: () async {
                                                HomeCubit.get(context)
                                                    .getMedical();
                                              },
                                              child: LayoutBuilder(builder:
                                                  (context, constraints) {
                                                return SingleChildScrollView(
                                                  physics:
                                                      AlwaysScrollableScrollPhysics(),
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height:
                                                          constraints.maxHeight,
                                                      child: Text(
                                                          style: TextStyle(
                                                              fontSize: 13.sp),
                                                          AppStrings
                                                              .thereIsNoMedicalServices
                                                              .tr())),
                                                );
                                              }),
                                            ),
                                    );
                                  },
                                ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
