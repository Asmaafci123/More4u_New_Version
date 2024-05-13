import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more4u/core/constants/app_strings.dart';
import 'package:more4u/custom_icons.dart';
import '../../domain/entities/benefit.dart';
import '../widgets/utils/app_bar.dart';
import 'cubits/benefit_details_cubit.dart';
import '../../core/constants/constants.dart';
import '../../injection_container.dart';
import '../benefit_redeem/BenefitRedeemScreen.dart';

class BenefitDetailedScreen extends StatefulWidget {
  static const routeName = 'BenefitDetailedScreen';
  final Benefit benefit;

  const BenefitDetailedScreen({Key? key, required this.benefit})
      : super(key: key);

  @override
  _BenefitDetailedScreenState createState() => _BenefitDetailedScreenState();
}

class _BenefitDetailedScreenState extends State<BenefitDetailedScreen>
    with TickerProviderStateMixin {
  late BenefitDetailsCubit _cubit;

  @override
  void initState() {
    _cubit = sl<BenefitDetailsCubit>()..benefit = widget.benefit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);

    return BlocConsumer<BenefitDetailsCubit, BenefitDetailsState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is BenefitDetailsSuccessState) {
        }
      },
      builder: (context, state) {
        ScrollController _controller = ScrollController();
        ScrollController _controller1 = ScrollController();
        return Scaffold(
          appBar: myAppBar(AppStrings.benefitDetails.tr()),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  widget.benefit.benefitCardAPI,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/more4u_card.png',
                      fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Text(
                              widget.benefit.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                  color: mainColor),
                            ),
                            Spacer(),
                            Icon(CustomIcons
                                .ph_arrows_counter_clockwise_duotone),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              '${widget.benefit.timesUserReceiveThisBenefit}/${widget.benefit.times}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: greyColor,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.w),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      AppStrings.description.tr(),
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                height: 75.h,
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.w),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      AppStrings.conditions.tr(),
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                height: 75.h,
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.w),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      AppStrings.workflow.tr(),
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
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
                              Scrollbar(
                                  thumbVisibility: true,
                                  trackVisibility: false,
                                  controller: _controller1,
                                  child: ListView.builder(
                                    controller: _controller1,
                                    itemBuilder: (context, index) => Text(
                                      _cubit.benefit?.benefitDescriptionList![
                                              index] ??
                                          '',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color:index==0?mainColor: greyColor,
                                        fontWeight:index==0? FontWeight.bold:FontWeight.normal
                                      ),
                                    ),
                                    itemCount: _cubit.benefit
                                        ?.benefitDescriptionList!.length,
                                  )),
                              MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: Scrollbar(
                                  controller: _controller,
                                  thumbVisibility: true,
                                  trackVisibility: false,
                                  child: ListView(
                                    controller: _controller,
                                    //scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    padding: EdgeInsets.only(right: 8.w),
                                    children: [
                                      conditionItem(
                                          prefix: _cubit
                                                      .benefit
                                                      ?.benefitConditions
                                                      ?.type! ==
                                                  'Individual'
                                              ? CustomIcons.user
                                              : CustomIcons.users_alt,
                                          suffix: _cubit
                                                      .benefit
                                                      ?.benefitApplicable
                                                      ?.type ==
                                                  true
                                              ? CustomIcons.circle_check_regular
                                              : CustomIcons
                                                  .circle_xmark_regular,
                                          label: AppStrings.type.tr(),
                                          value: _cubit.benefit
                                              ?.benefitConditions?.type),
                                      conditionItem(
                                          prefix: CustomIcons.stats,
                                          suffix: _cubit
                                                      .benefit
                                                      ?.benefitApplicable
                                                      ?.age ==
                                                  true
                                              ? CustomIcons.circle_check_regular
                                              : CustomIcons
                                                  .circle_xmark_regular,
                                          label: AppStrings.age.tr(),
                                          value: _cubit
                                              .benefit?.benefitConditions?.age),
                                      conditionItem(
                                          prefix: CustomIcons.clock,
                                          suffix: _cubit
                                                      .benefit
                                                      ?.benefitApplicable
                                                      ?.workDuration ==
                                                  true
                                              ? CustomIcons.circle_check_regular
                                              : CustomIcons
                                                  .circle_xmark_regular,
                                          label: AppStrings.workDuration.tr(),
                                          value: _cubit
                                              .benefit
                                              ?.benefitConditions
                                              ?.workDuration),
                                      conditionItem(
                                          prefix: Icons.event_available,
                                          suffix: _cubit
                                                      .benefit
                                                      ?.benefitApplicable
                                                      ?.dateToMatch ==
                                                  true
                                              ? CustomIcons.circle_check_regular
                                              : CustomIcons
                                                  .circle_xmark_regular,
                                          label: AppStrings.dateToMatch.tr(),
                                          value: _cubit.benefit
                                              ?.benefitConditions?.dateToMatch),
                                      conditionItem(
                                          prefix: CustomIcons.venus_mars,
                                          suffix: _cubit
                                                      .benefit
                                                      ?.benefitApplicable
                                                      ?.gender ==
                                                  true
                                              ? CustomIcons.circle_check_regular
                                              : CustomIcons
                                                  .circle_xmark_regular,
                                          label: AppStrings.gender.tr(),
                                          value: _cubit.benefit
                                              ?.benefitConditions?.gender),
                                      conditionItem(
                                          prefix: CustomIcons.bitmap,
                                          suffix: _cubit
                                                      .benefit
                                                      ?.benefitApplicable
                                                      ?.maritalStatus ==
                                                  true
                                              ? CustomIcons.circle_check_regular
                                              : CustomIcons
                                                  .circle_xmark_regular,
                                          label: AppStrings.maritalStatus.tr(),
                                          value: _cubit
                                              .benefit
                                              ?.benefitConditions
                                              ?.maritalStatus),
                                      conditionItem(
                                          prefix: Icons.trending_down,
                                          suffix: _cubit
                                                      .benefit
                                                      ?.benefitApplicable
                                                      ?.minParticipant ==
                                                  true
                                              ? CustomIcons.circle_check_regular
                                              : CustomIcons
                                                  .circle_xmark_regular,
                                          label:
                                              AppStrings.minParticipants.tr(),
                                          value: _cubit
                                              .benefit
                                              ?.benefitConditions
                                              ?.minParticipant),
                                      conditionItem(
                                          prefix: Icons.trending_up,
                                          suffix: _cubit
                                                      .benefit
                                                      ?.benefitApplicable
                                                      ?.maxParticipant ==
                                                  true
                                              ? CustomIcons.circle_check_regular
                                              : CustomIcons
                                                  .circle_xmark_regular,
                                          label:
                                              AppStrings.maxParticipants.tr(),
                                          value: _cubit
                                              .benefit
                                              ?.benefitConditions
                                              ?.maxParticipant),
                                      conditionItem(
                                          prefix: CustomIcons.person_solid,
                                          suffix: _cubit
                                                      .benefit
                                                      ?.benefitApplicable
                                                      ?.payrollArea ==
                                                  true
                                              ? CustomIcons.circle_check_regular
                                              : CustomIcons
                                                  .circle_xmark_regular,
                                          label: AppStrings.payrollArea.tr(),
                                          value: _cubit.benefit
                                              ?.benefitConditions?.payrollArea),
                                      conditionItem(
                                          prefix: CustomIcons.document,
                                          suffix: CustomIcons.loading,
                                          label:
                                              AppStrings.requiredDocuments.tr(),
                                          value: _cubit
                                              .benefit
                                              ?.benefitConditions
                                              ?.requiredDocuments),
                                    ],
                                  ),
                                ),
                              ),
                              _cubit.benefit!.benefitWorkflows!.isNotEmpty
                                  ? Container(
                                      padding: EdgeInsets.all(8),
                                      color: Colors.white,
                                      child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          return IntrinsicHeight(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 30.w,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: whiteGreyColor,
                                                          width: 3.0,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        '${index + 1}',
                                                        style:  TextStyle(
                                                          fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                whiteGreyColor),
                                                      ),
                                                    ),
                                                    if (index <
                                                        _cubit
                                                                .benefit!
                                                                .benefitWorkflows!
                                                                .length -
                                                            1)
                                                      Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      2.h),
                                                          height: 30.h,
                                                          width: 2.w,
                                                          color: whiteGreyColor,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 8.w,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _cubit.benefit!
                                                              .benefitWorkflows![
                                                          index],
                                                      style: TextStyle(
                                                          fontSize: 12.sp),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        itemCount: _cubit
                                            .benefit!.benefitWorkflows!.length,
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                      AppStrings.noApprovalWorkflowNeeded.tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: greyColor,
                                      ),
                                    ))
                            ],
                          ),
                        ),
                        if (widget.benefit.times ==
                                widget
                                    .benefit.timesUserReceiveThisBenefit ||
                            (widget.benefit.hasHoldingRequests != null &&
                                widget.benefit.hasHoldingRequests!))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CustomIcons.exclamation,
                                color: redColor,
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              widget.benefit.times ==
                                      widget.benefit
                                          .timesUserReceiveThisBenefit
                                  ? Text(
                                      AppStrings.youUsedAllCards.tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: redColor,
                                        fontSize: 12.sp,
                                      ),
                                    )
                                  : Text(
                                      AppStrings.youUsedThisCardBefore.tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: redColor,
                                        fontSize: 12.sp,
                                      ),
                                    )
                            ],
                          ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: Center(
                            child: SizedBox(
                              width: 187.w,
                              height: 45.h,
                              child: ElevatedButton(
                                  onPressed: _cubit.benefit != null
                                      ? (_cubit.benefit!.userCanRedeem
                                          ? () {
                                              Navigator.pushNamed(context,
                                                  BenefitRedeemScreen.routeName,
                                                  arguments: widget.benefit);
                                            }
                                          : null)
                                      : null,
                                  child: Text(
                                    AppStrings.redeem.tr(),
                                    style: TextStyle(fontSize: 12.sp),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget conditionItem(
      {required String label,
      String? value,
      required IconData prefix,
      required IconData suffix}) {
    return value != null
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Icon(prefix, color: mainColor, size: 20.r),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(
                    child: RichText(
                      softWrap: true,
                      text: TextSpan(children: [
                        TextSpan(
                          text: '$label   ',
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: value,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: greyColor,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      suffix,
                      size: 20.r,
                      color: suffix == CustomIcons.circle_check_regular
                          ? Colors.green
                          : suffix == CustomIcons.loading
                              ? Colors.orange
                              : redColor,
                    ),
                  )
                ],
              ),
            ),
          )
        : const SizedBox();
  }

}
