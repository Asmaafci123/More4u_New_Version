import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:more4u/core/constants/app_strings.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:more4u/presentation/my_benefit_requests/cubits/my_benefit_requests_cubit.dart';
import 'package:more4u/presentation/widgets/banner.dart';
import 'package:timeago/timeago.dart';

import '../../core/constants/constants.dart';
import '../../custom_icons.dart';
import '../../domain/entities/benefit_request.dart';
import '../../injection_container.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/helpers.dart';
import '../widgets/utils/app_bar.dart';
import '../widgets/utils/loading_dialog.dart';
import '../widgets/utils/message_dialog.dart';

class MyBenefitRequestsScreen extends StatefulWidget {
  static const routeName = 'MyBenefitRequestsScreen';

  final int benefitID;
  final int requestNumber;

  const MyBenefitRequestsScreen(
      {Key? key, required this.benefitID, this.requestNumber = -1})
      : super(key: key);

  @override
  State<MyBenefitRequestsScreen> createState() =>
      _MyBenefitRequestsScreenState();
}

class _MyBenefitRequestsScreenState extends State<MyBenefitRequestsScreen> {
  late MyBenefitRequestsCubit _cubit;

  @override
  void initState() {
    _cubit = sl<MyBenefitRequestsCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getMyBenefitRequests(
          benefitId: widget.benefitID, requestNumber: widget.requestNumber);
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
    return BlocConsumer(
      bloc: _cubit,
      listener: (context, state) {
        if (state is MyBenefitRequestsLoadingState) {
          loadingAlertDialog(context);
        }
        if (state is MyBenefitRequestsSuccessState) {
          Navigator.pop(context);
        }
        if (state is MyBenefitRequestsErrorState) {
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
                onPressedOk: () => Navigator.pop(context));
          }

        }
        if (state is CancelRequestLoadingState) {
          loadingAlertDialog(context);
        }
        if (state is CancelRequestSuccessState) {
          Navigator.pop(context);

          showMessageDialog(
              context: context,
              isSucceeded: true,
              message: state.message,
              onPressedOk: () {
                _cubit.getMyBenefitRequests(
                    benefitId: widget.benefitID,
                    requestNumber: widget.requestNumber);
              });
        }
        if (state is CancelRequestErrorState) {
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
                onPressedOk: () {
                  Navigator.pop(context);
                  _cubit.getMyBenefitRequests(benefitId: widget.benefitID);
                });
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: myAppBar(AppStrings.benefitRequests.tr()),
          drawer: const DrawerWidget(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    _cubit.myBenefitRequests.isNotEmpty
                        ? _cubit.myBenefitRequests.first.benefitCardAPI ?? ''
                        : '',
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/more4u_card.png',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: Text(
                      _cubit.myBenefitRequests.isNotEmpty
                          ? _cubit.myBenefitRequests.first.benefitName ?? ''
                          : '',
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: mainColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => myBenefitRequestCard(
                        request: _cubit.myBenefitRequests[index]),
                    itemCount: _cubit.myBenefitRequests.length,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Card myBenefitRequestCard({required BenefitRequest request}) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return dialog(request);
              });
        },
        child: MyBanner(
          message: request.status?.tr() ?? '',
          textStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700),
          location: BannerLocation.topEnd,
          color: getBenefitStatusColor(request.status ?? ''),
          child: Stack(
            children: [
              context.locale == Locale('en')
                  ? Positioned(
                      right: 2.w,
                      top: 2.h,
                      child: Icon(request.benefitType == AppStrings.group.tr()
                          ? CustomIcons.users_alt
                          : CustomIcons.user))
                  : Positioned(
                      left: 2.w,
                      top: 2.h,
                      child: Icon(request.benefitType == AppStrings.group.tr()
                          ? CustomIcons.users_alt
                          : CustomIcons.user)),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: context.locale.languageCode == 'en'
                        ? BorderSide(
                            width: 5.0.w,
                            color: getBenefitStatusColor(request.status ?? ''),
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
                            color: getBenefitStatusColor(request.status ?? '')),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: <Widget>[
                                Text(
                                  AppStrings.number.tr(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: greyColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Text(
                                  request.requestNumber.toString(),
                                  style: TextStyle(
                                    color: greyColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Row(
                              children: [
                                Icon(CustomIcons.clock),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Text(
                                  timeago.format(
                                      DateTime.parse(request.requestedat ?? ''),
                                      locale: context.locale.languageCode),
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: "Roboto",
                                      color: greyColor),
                                ),
                                Spacer(),
                                if (request.canCancel != null &&
                                    request.canCancel!)
                                  SizedBox(
                                    height: 30.h,
                                    width: 30.w,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: redColor,
                                          padding: EdgeInsets.zero),
                                      child: Center(
                                          child: Icon(
                                        CustomIcons.trash,
                                        size: 20.r,
                                      )),
                                      onPressed: () {
                                        AlertDialog alert = AlertDialog(
                                          title: Text(
                                              AppStrings.cancelRequest.tr()),
                                          content: Text(
                                            AppStrings
                                                .areYouSureYouWantToCancelThisRequest
                                                .tr(),
                                            style:
                                                TextStyle(fontFamily: 'Roboto'),
                                          ),
                                          actions: [
                                            TextButton(
                                              child:
                                                  Text(AppStrings.cancel.tr()),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: Text(AppStrings.ok.tr()),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _cubit.cancelRequest(
                                                    request.benefitId!,
                                                    request.requestNumber!);
                                              },
                                            ),
                                          ],
                                        );
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return alert;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                context.locale == Locale('en')
                                    ? Icon(Icons.arrow_circle_right, size: 30.r)
                                    : Icon(Icons.arrow_circle_left, size: 30.r),
                                SizedBox(
                                  width: 10.w,
                                )
                              ],
                            ),
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
      ),
    );
  }

  Widget dialog(BenefitRequest request) {
    return BlocBuilder(
      bloc: _cubit,
      builder: (context, state) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
          child: SingleChildScrollView(
            child: MeasureSize(
              onChange: (Size size) {
                _cubit.setChildSized(size);
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipPath(
                    clipper: MyClipper(),
                    child: MyBanner(
                      message: request.status?.tr() ?? '',
                      textStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700),
                      location: BannerLocation.topEnd,
                      color: getBenefitStatusColor(request.status ?? ''),
                      child: Container(
                        width: 500.0.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 14.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(
                                    color: Color(0xFFE7E7E7),
                                  )),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.r),
                                child: Image.network(
                                  request.benefitCardAPI ?? '',
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                    'assets/images/more4u_card.png',
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              _cubit.myBenefitRequests.isNotEmpty
                                  ? _cubit.myBenefitRequests.first
                                          .benefitName ??
                                      ''
                                  : '',
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: mainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${AppStrings.name.tr()} ',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: mainColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                    request.createdBy?.userName ?? '',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: greyColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${AppStrings.type.tr()} ',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: mainColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  request.benefitType ?? '',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: greyColor,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${AppStrings.from.tr()} ',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: mainColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  request.from ?? '',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: greyColor,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '${AppStrings.to.tr()} ',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: mainColor,
                                      fontWeight: FontWeight.bold),
                                 ),
                                Text(
                                  request.to ?? '',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: greyColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            if (request.sendToModel != null)
                              Row(
                                children: [
                                  Text(
                                    '${AppStrings.giftedTo.tr()}: ',
                                    style: TextStyle(
                                        color: greyColor,
                                        fontSize: 14.sp,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.w),
                                    child: Chip(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        side: BorderSide(
                                            color: Color(0xFFC1C1C1)),
                                      ),
                                      backgroundColor: Colors.transparent,
                                      label: Text(
                                          request.sendToModel?.userName ??
                                              ''),
                                      labelStyle: TextStyle(
                                          color: mainColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.sp),
                                    ),
                                  ),
                                ],
                              ),
                            if (request.fullParticipantsData?.isNotEmpty ??
                                false) ...[
                              Text(
                                '${AppStrings.participants.tr()}: ',
                                style: TextStyle(
                                    color: greyColor,
                                    fontSize: 14.sp,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold),
                              ),
                              Center(
                                child: Wrap(
                                  children: [
                                    ...request.fullParticipantsData!
                                        .map((participant) => Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.w),
                                              child: Chip(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  side: BorderSide(
                                                      color: Color(0xFFC1C1C1)),
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                                label: Text(
                                                    participant.userName ??
                                                        ''),
                                                labelStyle: TextStyle(
                                                    color: mainColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.sp),
                                              ),
                                            ))
                                        .toList()
                                  ],
                                ),
                              ),
                            ],
                            if (request.requestWorkFlowAPIs != null &&
                                request.requestWorkFlowAPIs!.isNotEmpty)
                              ListView.builder(
                                padding: EdgeInsets.only(top: 14.h),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return IntrinsicHeight(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: request
                                                          .requestWorkFlowAPIs![
                                                              index]
                                                          .status ==
                                                      'Pending'
                                                  ? Container(
                                                      width: 30.w,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: whiteGreyColor,
                                                          width: 3.0.w,
                                                        ),
                                                      ),
                                                      child: Icon(
                                                        CustomIcons
                                                            .hourglass_end,
                                                        color: whiteGreyColor,
                                                        size: 15.r,
                                                      ),
                                                    )
                                                  : request
                                                              .requestWorkFlowAPIs![
                                                                  index]
                                                              .status ==
                                                          'Approved'
                                                      ? Icon(
                                                          CustomIcons
                                                              .circle_check_regular,
                                                          color:
                                                              Color(0xFF00ED51),
                                                          size: 30.r,
                                                        )
                                                      : request
                                                                  .requestWorkFlowAPIs![
                                                                      index]
                                                                  .status ==
                                                              'Rejected'
                                                          ? Icon(
                                                              CustomIcons
                                                                  .circle_xmark_regular,
                                                              color: Color(
                                                                  0xFFE01B2B),
                                                              size: 30.r,
                                                            )
                                                          : Container(
                                                              width: 30.w,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    Border.all(
                                                                  color:
                                                                      whiteGreyColor,
                                                                  width: 3.0.w,
                                                                ),
                                                              ),
                                                              child: Text(
                                                                '${index + 1}',
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        whiteGreyColor),
                                                              ),
                                                            ),
                                            ),
                                            if (index <
                                                request.requestWorkFlowAPIs!
                                                        .length -
                                                    1)
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 2.h),
                                                  height: 50.h,
                                                  width: 2.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.r),
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        request
                                                                    .requestWorkFlowAPIs![
                                                                        index]
                                                                    .status ==
                                                                'Approved'
                                                            ? Colors.green
                                                            : request
                                                                        .requestWorkFlowAPIs![
                                                                            index]
                                                                        .status ==
                                                                    'Rejected'
                                                                ? Colors.red
                                                                : whiteGreyColor,
                                                        request
                                                                    .requestWorkFlowAPIs![
                                                                        index +
                                                                            1]
                                                                    .status ==
                                                                'Approved'
                                                            ? Colors.green
                                                            : request
                                                                        .requestWorkFlowAPIs![
                                                                            index +
                                                                                1]
                                                                        .status ==
                                                                    'Rejected'
                                                                ? Colors.red
                                                                : whiteGreyColor,
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 8.h, top: 4.h),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  request
                                                          .requestWorkFlowAPIs![
                                                              index]
                                                          .userName ??
                                                      '',
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 12.sp),
                                                ),
                                                Row(
                                                  children: [
                                                    request
                                                            .requestWorkFlowAPIs![
                                                                index]
                                                            .replayDate!
                                                            .contains('0001')
                                                        ? SizedBox()
                                                        : Text(
                                                            '${DateFormat('yyyy-MM-dd hh:mm aaa').format(DateTime.parse(request.requestWorkFlowAPIs![index].replayDate!))}',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    12.sp),
                                                          ),
                                                  ],
                                                ),
                                                Text(
                                                    request
                                                            .requestWorkFlowAPIs![
                                                                index]
                                                            .notes ??
                                                        '',
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        color: greyColor,
                                                        fontSize: 12.sp)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: request.requestWorkFlowAPIs!.length,
                              ),
                            SizedBox(
                              height: 120.h,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: _cubit.myChildSize.height - 90.h,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: 500.0.w,
                      height: 130.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: DottedLine(
                                dashLength: 8.w,
                                dashGapLength: 7.w,
                                lineThickness: 2,
                                dashColor: Colors.grey,
                              ),
                            ),
                          ),
                          Spacer(flex: 2),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12.h, horizontal: 14.w),
                            child: (request.status == 'Pending' ||
                                    request.status == 'InProgress')
                                ? Text(
                                    AppStrings
                                        .followUpYourRequestToKnowIfApprovedOrNot
                                        .tr(),
                                    style: TextStyle(
                                        color: redColor, fontFamily: 'Roboto',fontSize: 14.sp,),

                                    textAlign: TextAlign.center)
                                : request.status == 'Approved'
                                    ? Column(
                                        children: [
                                          Text(
                                            AppStrings.congratulations.tr(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: greenColor,
                                              fontSize: 18.sp,
                                              height: 0.8,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            AppStrings
                                                .enjoyWithYourFriendAndFamily
                                                .tr(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: greyColor,
                                              fontSize: 14.sp,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Text(
                                            AppStrings.oOPsSorry.tr(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: redColor,
                                              fontSize: 18.sp,
                                              height: 0.8,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            AppStrings.tryAgainLater.tr(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: greyColor,
                                              fontSize: 14.sp,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                          ),
                          Spacer(flex: 10),
                        ],
                      ),
                    ),
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

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width + 1.w, size.height);
    path.lineTo(size.width, 0.0);
    path.addOval(Rect.fromCircle(
        center: Offset(0.0, size.height - 90.h), radius: 15.0.w));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height - 90.h), radius: 15.0.w));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

typedef void OnWidgetSizeChange(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  final OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }
}
