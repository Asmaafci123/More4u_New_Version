import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more4u/core/constants/app_strings.dart';
import 'package:more4u/presentation/my_benefit_requests/my_benefit_requests_screen.dart';
import 'package:more4u/presentation/widgets/banner.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart';
import '../../core/constants/constants.dart';
import '../../custom_icons.dart';
import '../../domain/entities/benefit.dart';
import '../../injection_container.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/helpers.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/utils/app_bar.dart';
import '../widgets/utils/loading_dialog.dart';
import '../widgets/utils/message_dialog.dart';
import 'cubits/my_benefits_cubit.dart';

class MyBenefitsScreen extends StatefulWidget {
  static const routeName = 'MyBenefitsScreen';

  const MyBenefitsScreen({Key? key}) : super(key: key);

  @override
  State<MyBenefitsScreen> createState() => _MyBenefitsScreenState();
}

class _MyBenefitsScreenState extends State<MyBenefitsScreen>
    with TickerProviderStateMixin {
  late MyBenefitsCubit _cubit;

  @override
  void initState() {
    _cubit = sl<MyBenefitsCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getMyBenefits();
    });
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 5, vsync: this);
    if (context.locale.languageCode == 'ar') {
      timeago.setLocaleMessages('ar', ArMessages());
    }
    return BlocConsumer(
      bloc: _cubit,
      listener: (context, state) {
        if (state is GetMyBenefitsLoadingState) {
          loadingAlertDialog(context);
        }
        if (state is GetMyBenefitsSuccessState) {
          Navigator.pop(context);
        }
        if (state is GetMyBenefitsErrorState) {
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
                  context: context, isSucceeded: false, message: state.message);
            }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: myAppBar(AppStrings.myRequests.tr()),
          drawer: const DrawerWidget(),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MyAppBar(),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Text(
                      AppStrings.myRequests.tr(),
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'Joti',
                          color: redColor,
                          fontWeight: FontWeight.bold),
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
                      tabs: [
                        Tab(
                          height: 75.h,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                AppStrings.all.tr(),
                                style: TextStyle(fontSize: 14.sp),
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
                              child: Text(AppStrings.pending.tr(),
                                  style: TextStyle(fontSize: 14.sp)),
                            ),
                          ),
                        ),
                        Tab(
                          height: 75.h,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(AppStrings.inProgress.tr(),
                                  style: TextStyle(fontSize: 14.sp)),
                            ),
                          ),
                        ),
                        Tab(
                          height: 75.h,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(AppStrings.approved.tr(),
                                  style: TextStyle(fontSize: 14.sp)),
                            ),
                          ),
                        ),
                        Tab(
                          height: 75.h,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(AppStrings.rejected.tr(),
                                  style: TextStyle(fontSize: 14.sp)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _cubit.myAllBenefits.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  _cubit.getMyBenefits();
                                },
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) =>
                                      myBenefitCard(
                                          benefit: _cubit.myAllBenefits[index]),
                                  itemCount: _cubit.myAllBenefits.length,
                                ),
                              )
                            : RefreshIndicator(
                                triggerMode:
                                    RefreshIndicatorTriggerMode.anywhere,
                                onRefresh: () async {
                                  _cubit.getMyBenefits();
                                },
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return SingleChildScrollView(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        child: Container(
                                            alignment: Alignment.center,
                                            height: constraints.maxHeight,
                                            child: Center(
                                                child: Text(AppStrings
                                                    .noBenefitAvailable
                                                    .tr()))));
                                  },
                                ),
                              ),
                        _cubit.myPendingBenefits.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  _cubit.getMyBenefits();
                                },
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) =>
                                      myBenefitCard(
                                          benefit:
                                              _cubit.myPendingBenefits[index]),
                                  itemCount: _cubit.myPendingBenefits.length,
                                ),
                              )
                            : RefreshIndicator(
                                triggerMode:
                                    RefreshIndicatorTriggerMode.anywhere,
                                onRefresh: () async {
                                  _cubit.getMyBenefits();
                                },
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return SingleChildScrollView(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        child: Container(
                                            alignment: Alignment.center,
                                            height: constraints.maxHeight,
                                            child: Center(
                                                child: Text(AppStrings
                                                    .noBenefitAvailable
                                                    .tr()))));
                                  },
                                ),
                              ),
                        _cubit.myInProgressBenefits.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  _cubit.getMyBenefits();
                                },
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) =>
                                      myBenefitCard(
                                          benefit: _cubit
                                              .myInProgressBenefits[index]),
                                  itemCount: _cubit.myInProgressBenefits.length,
                                ),
                              )
                            : RefreshIndicator(
                                triggerMode:
                                    RefreshIndicatorTriggerMode.anywhere,
                                onRefresh: () async {
                                  _cubit.getMyBenefits();
                                },
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return SingleChildScrollView(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        child: Container(
                                            alignment: Alignment.center,
                                            height: constraints.maxHeight,
                                            child: Center(
                                                child: Text(AppStrings
                                                    .noBenefitAvailable
                                                    .tr()))));
                                  },
                                ),
                              ),
                        _cubit.myApprovedBenefits.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  _cubit.getMyBenefits();
                                },
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) =>
                                      myBenefitCard(
                                          benefit:
                                              _cubit.myApprovedBenefits[index]),
                                  itemCount: _cubit.myApprovedBenefits.length,
                                ),
                              )
                            : RefreshIndicator(
                                triggerMode:
                                    RefreshIndicatorTriggerMode.anywhere,
                                onRefresh: () async {
                                  _cubit.getMyBenefits();
                                },
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return SingleChildScrollView(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        child: Container(
                                            alignment: Alignment.center,
                                            height: constraints.maxHeight,
                                            child: Center(
                                                child: Text(AppStrings
                                                    .noBenefitAvailable
                                                    .tr()))));
                                  },
                                ),
                              ),
                        _cubit.myRejectedBenefits.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  _cubit.getMyBenefits();
                                },
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) =>
                                      myBenefitCard(
                                          benefit:
                                              _cubit.myRejectedBenefits[index]),
                                  itemCount: _cubit.myRejectedBenefits.length,
                                ),
                              )
                            : RefreshIndicator(
                                triggerMode:
                                    RefreshIndicatorTriggerMode.anywhere,
                                onRefresh: () async {
                                  _cubit.getMyBenefits();
                                },
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return SingleChildScrollView(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        child: Container(
                                            alignment: Alignment.center,
                                            height: constraints.maxHeight,
                                            child: Center(
                                                child: Text(AppStrings
                                                    .noBenefitAvailable
                                                    .tr()))));
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget myBenefitCard({required Benefit benefit}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 0),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, MyBenefitRequestsScreen.routeName,
                    arguments: benefit.id)
                .whenComplete(() => _cubit.getMyBenefits());
          },
          child: MyBanner(
            message: benefit.lastStatus?.tr() ?? '',
            textStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700),
            location: BannerLocation.topEnd,
            color: getBenefitStatusColor(benefit.lastStatus ?? ''),
            child: Stack(
              children: [
                context.locale == Locale('en')
                    ? Positioned(
                        right: 2.w,
                        top: 2.h,
                        child: Icon(benefit.benefitType == AppStrings.group.tr()
                            ? CustomIcons.users_alt
                            : CustomIcons.user))
                    : Positioned(
                        left: 2.w,
                        top: 2.h,
                        child: Icon(benefit.benefitType == AppStrings.group.tr()
                            ? CustomIcons.users_alt
                            : CustomIcons.user)),
                Container(
                  height: 105.h,
                  decoration: BoxDecoration(
                    border: Border(
                      left: context.locale.languageCode == 'en'
                          ? BorderSide(
                              width: 5.0.w,
                              color: getBenefitStatusColor(
                                  benefit.lastStatus ?? ''),
                            )
                          : BorderSide(
                              width: 2.0.w,
                              color: const Color(0xFFE7E7E7),
                            ),
                      right: context.locale.languageCode == 'en'
                          ? BorderSide(
                              width: 2.0.w,
                              color: const Color(0xFFE7E7E7),
                            )
                          : BorderSide(
                              width: 5.0.w,
                              color: getBenefitStatusColor(
                                  benefit.lastStatus ?? ''),
                            ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              // border: Border.all()
                              ),
                          child: Image.network(
                            benefit.benefitCardAPI,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/images/more4u_card.png',
                              fit: BoxFit.fill,
                            ),
                            fit: BoxFit.fill,
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  benefit.name,
                                  style: TextStyle(
                                    color: mainColor,
                                    fontSize: 14.sp,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(CustomIcons
                                        .ph_arrows_counter_clockwise_duotone),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Text(
                                      '${benefit.timesUserReceiveThisBenefit}/${benefit.times}',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: "Roboto",
                                          color: greyColor),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      '${benefit.totalRequestsCount} ${AppStrings.requests.tr()}',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: "Roboto",
                                          color: greyColor),
                                    ),
                                    Spacer(),
                                    Icon(Icons.arrow_circle_right, size: 30.r),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
