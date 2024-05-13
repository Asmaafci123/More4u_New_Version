import 'package:auto_size_text/auto_size_text.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:more4u/core/constants/api_path.dart';
import 'package:more4u/domain/entities/manage_requests_response.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:more4u/domain/entities/benefit_request.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';
import 'package:more4u/presentation/widgets/selection_chip.dart';
import 'package:more4u/presentation/widgets/utils/message_dialog.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/bottom_sheet/src/flexible_bottom_sheet_route.dart';
import '../../custom_icons.dart';
import '../../injection_container.dart';
import '../gallery_screen.dart';
import '../profile/profile_screen.dart';
import '../widgets/banner.dart';
import '../widgets/custom_switch.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/helpers.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/utils/app_bar.dart';
import '../widgets/utils/loading_dialog.dart';
import 'cubits/manage_requests_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart';

class  ManageRequestsScreen extends StatefulWidget {
  static const routeName = 'ManageRequestsScreen';
  final int requestNumber;

  const ManageRequestsScreen({Key? key, this.requestNumber = -1})
      : super(key: key);

  @override
  State<ManageRequestsScreen> createState() => _ManageRequestsScreenState();
}

class _ManageRequestsScreenState extends State<ManageRequestsScreen>
    with TickerProviderStateMixin {
  late ManageRequestsCubit _cubit;

  @override
  void initState() {
    _cubit = sl<ManageRequestsCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getBenefitsToManage(requestNumber: widget.requestNumber);
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
    if (context.locale.languageCode == 'ar') {
      timeago.setLocaleMessages('ar', ArMessages());
    }
    return BlocConsumer(
      bloc: _cubit,
      listener: (context, state) {
        if (state is GetRequestsToManageLoadingState) {
          loadingAlertDialog(context);
        }
        if (state is GetRequestsToManageSuccessState) {
          Navigator.pop(context);
        }
        if (state is GetRequestsToManageErrorState) {
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
                });
          }
        }
        if (state is AddRequestResponseLoadingState) {
          loadingAlertDialog(context);
        }
        if (state is AddRequestResponseSuccessState) {
          Navigator.pop(context);
          showMessageDialog(
              context: context,
              isSucceeded: true,
              message: state.message,
              onPressedOk: () {});
        }
        if (state is AddRequestResponseErrorState) {
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
                  _cubit.getBenefitsToManage(requestNumber: widget.requestNumber);
                });
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: myAppBar(AppStrings.manageRequests.tr()),
          resizeToAvoidBottomInset: false,
          drawer: const DrawerWidget(),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MyAppBar(),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Text(
                      AppStrings.manageRequests.tr(),
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'Joti',
                          color: redColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.r),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                    color: Colors.black26)
                              ]),
                          child: TextField(
                            style: TextStyle(fontSize: 12.sp),
                            controller: _cubit.userNumberSearch,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                            decoration: InputDecoration(
                              hintText: AppStrings.searchByUserNumber.tr(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.h, horizontal: 11.w),
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: whiteGreyColor),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: whiteGreyColor),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(10.r),
                        onTap: () {
                          _cubit.search();
                        },
                        child: Ink(
                          width: 35.w,
                          height: 34.w,
                          decoration: BoxDecoration(
                              color: mainColor,
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 10)
                              ],
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Center(
                              child: Icon(
                            // Icons.filter_list_alt,
                            CustomIcons.search__1_,
                            size: 17.r,
                            color: Colors.white,
                          )),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(10.r),
                        onTap: () {
                          buildShowModalBottomSheet(context);
                        },
                        child: Ink(
                          width: 35.w,
                          height: 34.w,
                          decoration: BoxDecoration(
                              color: mainColor,
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 10)
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Icon(
                            CustomIcons.settings_sliders,
                            size: 17.r,
                            color: Colors.white,
                          )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),
                  Expanded(
                    child: _cubit.benefitRequests.isNotEmpty
                        ? RefreshIndicator(
                            triggerMode: RefreshIndicatorTriggerMode.anywhere,
                            onRefresh: () async {
                              _cubit.getBenefitsToManage(
                                  requestNumber: widget.requestNumber);
                            },
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              // shrinkWrap: true,
                              itemBuilder: (context, index) =>
                                  requestCard(_cubit.benefitRequests[index]),
                              itemCount: _cubit.benefitRequests.length,
                            ),
                          )
                        : RefreshIndicator(
                            triggerMode: RefreshIndicatorTriggerMode.anywhere,
                            onRefresh: () async {
                              _cubit.getBenefitsToManage(
                                  requestNumber: widget.requestNumber);
                            },
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: constraints.maxHeight,
                                      child: Text(
                                        AppStrings.noRequestsToManage.tr(),
                                        style: TextStyle(fontSize: 12.sp),
                                      )));
                            }),
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

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder(
            bloc: _cubit,
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 12.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 51.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xffd9d9d9),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          AppStrings.filtration.tr(),
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppStrings.benefitHasWarning.tr(),
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ), //Text

                          Spacer(),
                          CustomSwitch(
                            value: _cubit.hasWarning,
                            onChanged: (bool? value) {
                              _cubit.changeContainWarning(value!);
                            },
                            activeColor: mainColor,
                          ), //Checkbox
                        ], //<Widget>[]
                      ),
                      Text(
                        AppStrings.action.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff7f7f7f),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Wrap(
                        children: [
                          SelectionChip(
                              label: AppStrings.holding.tr(),
                              index: 1,
                              selectedIndex: _cubit.actionCurrentIndex,
                              selectIndex: _cubit.selectAction),
                          SelectionChip(
                              label: AppStrings.approved.tr(),
                              index: 3,
                              selectedIndex: _cubit.actionCurrentIndex,
                              selectIndex: _cubit.selectAction),
                          SelectionChip(
                              label: AppStrings.rejected.tr(),
                              index: 4,
                              selectedIndex: _cubit.actionCurrentIndex,
                              selectIndex: _cubit.selectAction),
                        ],
                      ),
                      Text(
                        AppStrings.benefitType.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff7f7f7f),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Wrap(
                        children: [
                          SelectionChip(
                              label: AppStrings.individual.tr(),
                              index: 2,
                              selectedIndex: _cubit.typeCurrentIndex,
                              selectIndex: _cubit.selectType),
                          SelectionChip(
                              label: AppStrings.group.tr(),
                              index: 3,
                              selectedIndex: _cubit.typeCurrentIndex,
                              selectIndex: _cubit.selectType),
                        ],
                      ),
                      if (userData!.isAdmin!) ...[
                        Text(
                          AppStrings.department.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff7f7f7f),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        DropdownButtonFormField<Department>(
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.normal,
                                color: Colors.black87),
                            value: _cubit.selectedDepartment,
                            decoration: InputDecoration(
                              isDense: true,
                              label: Text(AppStrings.department.tr()),
                              border: OutlineInputBorder(),
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.w600),
                              contentPadding: EdgeInsets.all(3.0),
                              prefixIcon: const Icon(
                                CustomIcons.apps,
                              ),
                            ),
                            items: [
                              DropdownMenuItem<Department>(
                                child: Text(AppStrings.any.tr(),
                                    style: TextStyle(
                                      color: _cubit.departmentCurrentIndex == -1
                                          ? mainColor
                                          : Colors.black,
                                    )),
                                value: Department(name: 'Any', id: -1),
                              ),
                              ..._cubit.departments!
                                  .map((e) => DropdownMenuItem<Department>(
                                        child: Text(e.name!,
                                            style:
                                                e == _cubit.selectedDepartment
                                                    ? TextStyle(
                                                        color: mainColor,
                                                      )
                                                    : TextStyle(
                                                        color: Colors.black87,
                                                      )),
                                        value: e,
                                      ))
                                  .toList()
                            ],
                            onChanged: (department) =>
                                _cubit.selectDepartment(department!))
                      ],
                      Text(
                        AppStrings.date.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff7f7f7f),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      DateTimeField(
                        controller: _cubit.fromText,
                        decoration: InputDecoration(
                            label: Text(AppStrings.from.tr()),
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12.sp),
                            contentPadding: EdgeInsets.all(3.0),
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              size: 25.r,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                _cubit.changeFromDate(null);
                              },
                              iconSize: 25.r,
                            )),

                        format: DateFormat("yyyy-MM-dd"),
                        style: TextStyle(fontSize: 12.sp),
                        onShowPicker: (context, currentValue) async {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year),
                            initialDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 1)
                                .add(Duration(days: -1)),
                          );
                        },
                        onChanged: (date) {
                          _cubit.changeFromDate(date);
                        },
                      ),
                      SizedBox(height: 16.h),
                      DateTimeField(
                        controller: _cubit.toText,
                        enabled: _cubit.fromDate != null,
                        decoration: InputDecoration(
                          label: Text(AppStrings.to.tr()),
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12.sp),
                          contentPadding: EdgeInsets.all(3.0),
                          prefixIcon: const Icon(
                            Icons.calendar_today,
                          ),
                        ),
                        format: DateFormat("yyyy-MM-dd"),
                        style: TextStyle(fontSize: 12.sp),
                        resetIcon: null,
                        onShowPicker: (context, currentValue) async {
                          return showDatePicker(
                              context: context,
                              firstDate: _cubit.fromDate ?? DateTime.now(),
                              initialDate: _cubit.toDate ?? DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 1)
                                  .add(Duration(days: -1)));
                        },
                        onChanged: (date) {
                          _cubit.changeToDate(date);
                        },
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          // height: 42.h,
                          width: 187.w,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _cubit.search();
                            },
                            child: Text(
                              AppStrings.done.tr(),
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.r))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  Card requestCard(BenefitRequest request) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 0),
      child: InkWell(
        onTap: () {
          _cubit.isBottomSheetOpened = true;
          buildShowDetailedModalBottomSheet(request);
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
                            color: getBenefitStatusColor(request.status ?? ''),
                          ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 10,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      // border: Border.all()
                                      ),
                                  child: Image.network(
                                    request.benefitCardAPI!,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                                'assets/images/more4u_card.png',
                                                fit: BoxFit.fill),
                                    fit: BoxFit.fill,
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                                if (request.warningMessage != null ||
                                    (request.hasDocuments != null &&
                                        request.hasDocuments!))
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 8.h),
                                    child: Icon(
                                      CustomIcons.shield_exclamation,
                                      size: 27.r,
                                      color: yellowColor,
                                    ),
                                  )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 9.w,
                          ),
                          Expanded(
                            flex: 9,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.benefitName ?? '',
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: 14.sp,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    timeago.format(
                                        DateTime.parse(
                                            request.requestedat ?? ''),
                                        locale: context.locale.languageCode),
                                    style: TextStyle(
                                      color: greyColor,
                                      //color: mainColor,
                                      fontSize: 12.sp,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: '${AppStrings.name.tr()}   ',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: mainColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: request.createdBy?.userName ??
                                            '',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: greyColor,
                                        ),
                                      ),
                                    ]),
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: '${AppStrings.number.tr()}   ',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: mainColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: request.requestNumber.toString(),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: greyColor,
                                        ),
                                      ),
                                    ]),
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text:
                                            '${AppStrings.requiredDate.tr()}   ',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: mainColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: request.from ?? '',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: greyColor,
                                        ),
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                      child: request.status == 'Cancelled'
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                    softWrap: true,
                                    text: TextSpan(
                                        children: [
                                      TextSpan(
                                        text:
                                            '${AppStrings.theRequestHasBeen.tr()} ',
                                        style: TextStyle(
                                          color: greyColor,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${AppStrings.cancelled.tr()} ',
                                        style: TextStyle(
                                          color: redColor,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ])),
                              ),
                            )
                          : request.userCanResponse == true
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 72.w,
                                      height: 40.h,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: redColor,
                                        ),
                                        onPressed: () => acceptOrReject(
                                            false, request.requestWorkflowId!),
                                        child: Text(
                                          AppStrings.reject.tr(),
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16.w,
                                    ),
                                    SizedBox(
                                      width: 72.w,
                                      height: 40.h,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: mainColor,
                                        ),
                                        onPressed: () => acceptOrReject(
                                            true, request.requestWorkflowId!),
                                        child: Text(
                                          AppStrings.accept.tr(),
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      AppStrings.details.tr(),
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 12.sp),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    context.locale == Locale('en')
                                        ? Icon(Icons.arrow_circle_right,
                                            size: 30.r)
                                        : Icon(Icons.arrow_circle_left,
                                            size: 30.r),
                                  ],
                                )
                              : request.myAction == null
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        AppStrings.dateHasBeenExpired.tr(),
                                        style: TextStyle(
                                          color: redColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.h),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                            softWrap: true,
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: request.myAction
                                                        ?.whoIsResponseName ??
                                                    AppStrings.you.tr(),
                                                style: TextStyle(
                                                  color: greyColor,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              TextSpan(
                                                text: context.locale
                                                            .languageCode ==
                                                        'ar'
                                                    ? request.myAction
                                                                ?.action ==
                                                            "Rejected"
                                                        ? ' رفضت'
                                                        : ' وافقت'
                                                    : ' ${request.myAction?.action ?? ''}',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: getBenefitStatusColor(
                                                      request.myAction
                                                              ?.action ??
                                                          ''),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    ' ${AppStrings.thisRequest.tr()} ',
                                                style: TextStyle(
                                                  color: greyColor,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              TextSpan(
                                                text: timeago.format(
                                                    DateTime.parse(request
                                                            .myAction
                                                            ?.replayDate ??
                                                        ''),
                                                    locale: context
                                                        .locale.languageCode),
                                                style: TextStyle(
                                                    color: greyColor,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ])),
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
    );
  }

  Future<dynamic> buildShowDetailedModalBottomSheet(BenefitRequest request) {
    void openGallery({int index = 0}) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => GalleryScreen(
                images: request.documentsPath!,
                index: index,
              )));
    }

    return showFlexibleBottomSheet(
        isModal: true,
        isDismissible: true,
        minHeight: 0.25,
        initHeight: 1.0 -
            MediaQuery.of(context).viewPadding.top /
                MediaQuery.of(context).size.height,
        maxHeight: 1.0 -
            MediaQuery.of(context).viewPadding.top /
                MediaQuery.of(context).size.height,
        isExpand: false,
        bottomSheetColor: Colors.transparent,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.r),
                topRight: Radius.circular(25.r))),
        context: context,
        builder: (
          BuildContext context,
          ScrollController scrollController,
          double bottomSheetOffset,
        ) {
          return BlocBuilder(
            bloc: _cubit,
            builder: (context, state) {
              return ClipRRect(
                child: MyBanner(
                  message: request.status?.tr() ?? '',
                  textStyle:
                      TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700),
                  location: BannerLocation.topEnd,
                  color: getBenefitStatusColor(request.status ?? ''),
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          controller: scrollController,
                          children: [
                            Text(
                              request.benefitName ?? '',
                              style: TextStyle(
                                color: mainColor,
                                fontSize: 20.sp,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                        border: Border.all(
                                          color: Color(0xFFE7E7E7),
                                        )),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6.r),
                                      child: Image.network(
                                        request.benefitCardAPI!,
                                        errorBuilder: (context, error,
                                                stackTrace) =>
                                            Image.asset(
                                                'assets/images/more4u_card.png'),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Expanded(
                                  flex: 10,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${AppStrings.name.tr()}    ',
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                color: mainColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: AutoSizeText(
                                              request.createdBy?.userName ??
                                                  '',
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: greyColor,
                                                  height: 1.1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${AppStrings.requestNumber.tr()}    ',
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                color: mainColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${request.requestNumber}',
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
                                            '${AppStrings.type.tr()}    ',
                                            style: TextStyle(
                                                fontSize: 13.sp,
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
                                            '${AppStrings.requiredDate.tr()}    ',
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                color: mainColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            request.from ?? '',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${AppStrings.to.tr()}    ',
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                color: mainColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            request.to ?? '',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Divider(),
                            Text(
                              AppStrings.createdBy.tr(),
                              style: TextStyle(
                                color: mainColor,
                                fontSize: 14.sp,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 4.w),
                                    child: AutoSizeText(
                                      request.createdBy?.userName ?? '',
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: greyColor,
                                        fontSize: 12.sp,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: mainColor, width: 2),
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                      ),
                                      height: 130.h,
                                      width: 132.h,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                        child: state
                                                is GetRequestProfileAndDocumentsLoadingState
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : Image.network(
                                                request.createdBy!
                                                    .profilePictureAPI!,
                                                fit: BoxFit.cover,
                                                gaplessPlayback: true,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Image.asset(
                                                        'assets/images/profile_avatar_placeholder.png',
                                                        fit: BoxFit.cover),
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, ProfileScreen.routeName,
                                            arguments: {
                                              'user': request.createdBy
                                            });
                                      },
                                      child: Text(
                                        AppStrings.viewProfile.tr(),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (request.requestedat != null)
                                        Row(
                                          children: [
                                            Icon(CustomIcons.clock,color: mainColor,),
                                            SizedBox(
                                              width: 6.w,
                                            ),
                                            Text(
                                              '${AppStrings.at.tr()} ',
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: mainColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Flexible(
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  '${DateFormat('yyyy-MM-dd hh:mm aaa').format(DateTime.parse(request.requestedat ?? ''))}',
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    color: greyColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      Row(
                                        children: [
                                          Icon(CustomIcons.hastag,color: mainColor,),
                                          SizedBox(
                                            width: 6.w,
                                          ),
                                          Text(
                                            '${AppStrings.userNumber.tr()}    ',
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                color: mainColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            request.createdBy?.userNumber
                                                    .toString() ??
                                                '',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(CustomIcons.seedling_solid__1_,color: mainColor,),
                                          SizedBox(
                                            width: 6.w,
                                          ),
                                          Text(
                                            '${AppStrings.sapNumber.tr()}    ',
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                color: mainColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            request.createdBy?.sapNumber
                                                    .toString() ??
                                                '',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(CustomIcons.apps,color: mainColor,),
                                          SizedBox(
                                            width: 6.w,
                                          ),
                                          Text(
                                            '${AppStrings.department.tr()}    ',
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                color: mainColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Flexible(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                request.createdBy
                                                        ?.departmentName ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: greyColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(CustomIcons.person_solid,color: mainColor,),
                                          SizedBox(
                                            width: 6.w,
                                          ),
                                          Text(
                                            '${AppStrings.payrollArea.tr()}    ',
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                color: mainColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            request.createdBy?.collar ?? '',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            if (request.sendToModel != null) ...[
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    AppStrings.giftedTo.tr(),
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: 14.sp,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.w),
                                    child: SelectionChip(
                                        label:
                                            request.sendToModel?.userName ??
                                                '',
                                        index: 0,
                                        selectedIndex: 1,
                                        selectIndex: (_) {
                                          Navigator.pushNamed(
                                              context, ProfileScreen.routeName,
                                              arguments: {
                                                'user': request.sendToModel
                                              });
                                        }),
                                  ),
                                ],
                              ),
                            ],
                            if (request.fullParticipantsData != null) ...[
                              Divider(),
                              Text(
                                AppStrings.participants.tr(),
                                style: TextStyle(
                                  color: mainColor,
                                  fontSize: 14.sp,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Center(
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    ...request.fullParticipantsData!
                                        .map((participant) => SelectionChip(
                                            label:
                                                participant.userName ?? '',
                                            index: 0,
                                            selectedIndex: 1,
                                            selectIndex: (_) {
                                              Navigator.pushNamed(context,
                                                  ProfileScreen.routeName,
                                                  arguments: {
                                                    'user': participant
                                                  });
                                            }))
                                        .toList()
                                  ],
                                ),
                              ),
                            ],
                            if (request.hasDocuments != null &&
                                request.hasDocuments!) ...[
                              Divider(),
                              Text(
                                AppStrings.documents.tr(),
                                style: TextStyle(
                                  color: mainColor,
                                  fontSize: 14.sp,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              state is GetRequestProfileAndDocumentsLoadingState
                                  ? SizedBox(
                                      height: 120.h,
                                      child: Center(
                                          child: CircularProgressIndicator()))
                                  : SizedBox(
                                      height: 120.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              openGallery(index: index);
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 8.w),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: mainColor, width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Image.network(
                                                      request.documentsPath![
                                                          index],
                                                  width: 120.h,
                                                  height: 120.h,
                                                  fit: BoxFit.fill,
                                                  gaplessPlayback: true),
                                            ),
                                          );
                                        },
                                        // itemCount: _cubit.profileAndDocuments!
                                        //     .documents!.length,
                                        itemCount:
                                            request.documentsPath?.length ?? 0,
                                      ),
                                    ),
                              SizedBox(
                                height: 8.h,
                              ),
                            ],
                            if (request.warningMessage != null)
                              Padding(
                                padding: EdgeInsets.only(top: 16.h),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: '${AppStrings.warning.tr()} ',
                                      style: TextStyle(
                                          color: redColor,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: request.warningMessage ?? '',
                                      style: TextStyle(
                                          color: redColor,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ]),
                                ),
                              ),
                            SizedBox(
                              height: 8.h,
                            ),
                            request.userCanResponse == true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 130.w,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: redColor,
                                          ),
                                          onPressed: () => acceptOrReject(false,
                                              request.requestWorkflowId!),
                                          child: Text(
                                            AppStrings.reject.tr(),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16.w,
                                      ),
                                      SizedBox(
                                        width: 130.w,
                                        child: ElevatedButton(
                                          onPressed: () => acceptOrReject(
                                              true, request.requestWorkflowId!),
                                          child: Text(
                                            AppStrings.accept.tr(),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : request.myAction == null
                                    ? Align(
                                        child: RichText(
                                            softWrap: true,
                                            text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                    '${AppStrings.theRequestHasBeen.tr()} ',
                                                    style: TextStyle(
                                                      color: redColor,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '${AppStrings.cancelled.tr()} ',
                                                    style: TextStyle(
                                                      color: redColor,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                  ),
                                                ]))
                                      )
                                    :Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            RichText(
                                                softWrap: true,
                                                text: TextSpan(
                                                    children: [
                                                  TextSpan(
                                                    text: request.myAction
                                                            ?.whoIsResponseName ??
                                                        AppStrings.you.tr(),
                                                    style: TextStyle(
                                                      color: greyColor,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: context.locale
                                                                .languageCode ==
                                                            'ar'
                                                        ? request.myAction
                                                                    ?.action ==
                                                                "Rejected"
                                                            ? ' رفضت'
                                                            : ' وافقت'
                                                        : ' ${request.myAction?.action ?? ''}',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color:
                                                          getBenefitStatusColor(
                                                              request.myAction
                                                                      ?.action ??
                                                                  ''),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        ' ${AppStrings.thisRequest.tr()} ',
                                                    style: TextStyle(
                                                      color: greyColor,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: timeago.format(
                                                        DateTime.parse(request
                                                                .myAction
                                                                ?.replayDate ??
                                                            ''),
                                                        locale: context.locale
                                                            .toString()),
                                                    style: TextStyle(
                                                        color: greyColor,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ])),
                                            if (request.myAction?.notes != null)
                                              RichText(
                                                  softWrap: true,
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                      text:
                                                          '${AppStrings.notes.tr()}: ',
                                                      style: TextStyle(
                                                          color: greyColor,
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                      text: request.myAction
                                                              ?.notes ??
                                                          'test',
                                                      style: TextStyle(
                                                        color: greyColor,
                                                        fontSize: 14.sp,
                                                      ),
                                                    ),
                                                  ])),
                                          ],
                                        ),
                                      ),
                            SizedBox(
                              height: 20.h,
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
        }).whenComplete(() => _cubit.isBottomSheetOpened = false);
  }

  acceptOrReject(bool isAccepted, int requestWorkflowId) {
    showDialog(
      context: context,
      builder: (_) {
        TextEditingController _textController = TextEditingController();
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8),
          child: SingleChildScrollView(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    height: 300.h,
                    width: 500.0.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isAccepted
                              ? AppStrings.approveAndSendYourNote.tr()
                              : AppStrings.rejectAndSendYourNote.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isAccepted ? mainColor : redColor,
                            fontSize: 18.sp,
                            fontFamily: "Cairo",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        TextFormField(
                          controller: _textController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto',
                              fontSize: 12.sp),
                          decoration: InputDecoration(
                            isDense: true,
                            // contentPadding: EdgeInsets.symmetric(vertical: 0),
                            suffixIconConstraints:
                                BoxConstraints(maxHeight: 20.h, minWidth: 50.w),
                            prefixIconConstraints:
                                BoxConstraints(maxHeight: 80.h, minWidth: 50.w),
                            prefixIcon: Column(
                              children: [
                                Icon(
                                  CustomIcons.clipboard_regular,
                                  size: 20.r,
                                ),
                              ],
                            ),
                            border: OutlineInputBorder(),
                            labelText: AppStrings.notes.tr(),
                            labelStyle: TextStyle(fontSize: 14.sp),
                            hintText: AppStrings.enterYourNotes.tr(),
                            hintStyle: TextStyle(
                                color: Color(0xffc1c1c1), fontSize: 12.sp),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 300.h / 1.4,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: 500.0.w,
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 50.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                      ),
                                      side: BorderSide(
                                        width: 2.0.w,
                                        color:
                                            isAccepted ? mainColor : redColor,
                                      ),
                                      primary: Colors.white,
                                      onPrimary:
                                          isAccepted ? mainColor : redColor,
                                    ),
                                    child: Text(
                                      AppStrings.cancel.tr(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Roboto",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_cubit.isBottomSheetOpened) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                    var b = await _cubit.acceptOrRejectRequest(
                                        requestWorkflowId,
                                        isAccepted ? 1 : 2,
                                        _textController.text);
                                    if (b ?? false) {
                                      _cubit.removeRequest(requestWorkflowId);
                                      HomeCubit.get(context)
                                          .changePendingRequestsCount(
                                              _cubit.benefitRequests.length);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    side: BorderSide(
                                      width: 2.0.w,
                                      color: isAccepted ? mainColor : redColor,
                                    ),
                                    primary: isAccepted ? mainColor : redColor,
                                    onPrimary: Colors.white,
                                  ),
                                  child: Text(
                                    isAccepted
                                        ? AppStrings.accept.tr()
                                        : AppStrings.reject.tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Roboto",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.sp),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
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
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.addOval(Rect.fromCircle(
        center: Offset(0.0, size.height / 1.4), radius: 15.0.w));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height / 1.4), radius: 15.0.w));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
