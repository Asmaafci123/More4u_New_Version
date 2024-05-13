import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:more4u/core/constants/app_strings.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:more4u/domain/entities/participant.dart';
import 'package:more4u/presentation/benefit_redeem/cubits/redeem_cubit.dart';
import 'package:more4u/presentation/home/home_screen.dart';
import '../../core/utils/flutter_chips/src/chips_input.dart';
import '../../custom_icons.dart';
import '../../domain/entities/benefit.dart';
import '../../injection_container.dart';
import '../widgets/helpers.dart';
import '../widgets/utils/app_bar.dart';
import '../widgets/utils/loading_dialog.dart';
import '../widgets/utils/message_dialog.dart';

class BenefitRedeemScreen extends StatefulWidget {
  static const routeName = 'BenefitRedeemScreen';

  final Benefit benefit;

  const BenefitRedeemScreen({Key? key, required this.benefit})
      : super(key: key);

  @override
  _BenefitRedeemScreenState createState() => _BenefitRedeemScreenState();
}

class _BenefitRedeemScreenState extends State<BenefitRedeemScreen> {
  late RedeemCubit _cubit;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late double _keyboardSize;

  @override
  void initState() {
    _cubit = sl<RedeemCubit>()..initRedeem(widget.benefit);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.benefit.benefitType == AppStrings.group.tr() ||
          widget.benefit.isAgift) {
        _cubit.getParticipants();
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _keyboardSize = MediaQuery.of(context).viewInsets.bottom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RedeemCubit, RedeemState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is RedeemLoadingState) {
          loadingAlertDialog(context);
        }
        if (state is RedeemGetParticipantsSuccessState) {
          Navigator.pop(context);
        }
        if (state is RedeemGetParticipantsErrorState) {
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
        if (state is RedeemSuccessState) {
          Navigator.pop(context);
          showMessageDialog(
              context: context,
              isSucceeded: true,
              message: AppStrings.cardRedeemSucceeded.tr(),
              onPressedOk: () => Navigator.popUntil(
                  context, ModalRoute.withName(HomeScreen.routeName)));
        }
        if (state is RedeemSuccessState) {
          Navigator.pop(context);
          showMessageDialog(
              context: context,
              isSucceeded: true,
              message: AppStrings.cardRedeemSucceeded.tr(),
              onPressedOk: () => Navigator.popUntil(
                  context, ModalRoute.withName(HomeScreen.routeName)));
        }
        if (state is RedeemErrorState) {
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
                onPressedOk: () => Navigator.popUntil(
                    context, ModalRoute.withName(HomeScreen.routeName)));
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: myAppBar(AppStrings.redeem.tr()),
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(
                    widget.benefit.benefitCardAPI,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/images/more4u_card.png'),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 20.w, right: 20.w, top: 26.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_cubit.benefit.benefitType ==
                              AppStrings.group.tr()) ...[
                            TextFormField(
                              controller: _cubit.groupName,
                              validator: (text) {
                                if (text?.isEmpty ?? false) {
                                  return AppStrings.required.tr();
                                }
                                return null;
                              },
                              style:TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: mainColor,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.h),
                                suffixIconConstraints: BoxConstraints(
                                    maxHeight: 20.h, minWidth: 50.w),
                                prefixIcon: Icon(
                                  CustomIcons.users_alt,
                                  size: 25.r,
                                ),
                                border: OutlineInputBorder(),
                                labelText: AppStrings.sportType.tr(),
                                labelStyle: TextStyle(fontSize: 14.sp),
                                hintText: AppStrings.enterSportType.tr(),
                                errorStyle:TextStyle(fontSize: 12.sp) ,
                                hintStyle: TextStyle(
                                    color: Color(0xffc1c1c1), fontSize: 12.sp),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                          if (_cubit.showParticipantsField) ...[
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0, 0, 0, _keyboardSize),
                              child: ChipsInput<Participant>(
                                enabled: _cubit.enableParticipantsField,
                                textStyle: TextStyle(
                                  fontSize: 12.sp,
                                  height: 1,
                                  fontWeight: FontWeight.w400,
                                  color: mainColor,
                                ),
                                // enabled: false,
                                allowChipEditing: true,
                                decoration: InputDecoration(
                                  isDense: true,
                                  suffixIconConstraints: BoxConstraints(
                                      maxHeight: 20.h, minWidth: 50.w),
                                  prefixIcon: Icon(
                                    CustomIcons.users_alt,
                                    size: 20.r,
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: widget.benefit.isAgift
                                      ? AppStrings.coworkerName.tr()
                                      : AppStrings.groupParticipants.tr(),
                                  labelStyle: TextStyle(fontSize: 14.sp),
                                  hintText: widget.benefit.isAgift
                                      ? AppStrings.enterCoworkerName.tr()
                                      : AppStrings.enterYourGroupParticipants
                                          .tr(),
                                  hintStyle: TextStyle(
                                      color: const Color(0xffc1c1c1),
                                      fontSize: 12.sp),
                                  errorStyle: TextStyle(fontSize: 12.sp),
                                  errorText: _cubit.lowParticipantError,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                maxChips: widget.benefit.isAgift
                                    ? _cubit.benefit.maxParticipant
                                    : _cubit.benefit.maxParticipant - 1,
                                findSuggestions: (String query) {
                                  if (query.length > 1) {
                                    var lowercaseQuery = query.toLowerCase();
                                    return _cubit.participants.where((profile) {
                                      return profile.fullName
                                              .toLowerCase()
                                              .contains(query.toLowerCase()) ||
                                          profile.userNumber
                                              .toString()
                                              .toLowerCase()
                                              .contains(query.toLowerCase());
                                    }).toList(growable: false)
                                      ..sort((a, b) => a.fullName
                                          .toLowerCase()
                                          .indexOf(lowercaseQuery)
                                          .compareTo(b.fullName
                                              .toLowerCase()
                                              .indexOf(lowercaseQuery)));
                                  } else {
                                    return const <Participant>[];
                                  }
                                },
                                onChanged: _cubit.participantsOnChange,
                                chipBuilder: (context, state, profile) {
                                  return InputChip(
                                    padding: EdgeInsets.zero,
                                    deleteIconColor: mainColor,
                                    labelStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.normal,
                                        color: mainColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side:
                                          BorderSide(color: Color(0xFFC1C1C1)),
                                    ),
                                    backgroundColor: Color(0xFFE7E7E7),
                                    key: ObjectKey(profile),
                                    label: Text(
                                      profile.fullName,
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                    onDeleted: () {
                                      _cubit.participantOnRemove(profile);
                                      state.forceDeleteChip(profile);
                                    },
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  );
                                },
                                suggestionBuilder: (context, state, profile) {
                                  return ListTile(
                                    key: ObjectKey(profile),
                                    leading: CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/images/profile_avatar_placeholder.png'),
                                    ),
                                    title: Text(profile.fullName,
                                        style: TextStyle(fontSize: 12.sp)),
                                    subtitle:
                                        Text(profile.userNumber.toString()),
                                    onTap: () =>
                                        state.selectSuggestion(profile),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                          DateTimeField(
                            resetIcon: Icon(
                              Icons.close,
                              size: 25.r,
                            ),
                            style: TextStyle(fontSize: 12.sp),
                            controller: _cubit.startDate,
                            // validator: (value) => deliverDate == null ? translator.translate('required') : null,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10.h),
                              prefixIcon: Icon(
                                CustomIcons.calendar_days_solid__1_,
                                size: 20.r,
                              ),
                              suffixIcon: SizedBox(),
                              border: OutlineInputBorder(),
                              labelText: AppStrings.startFrom.tr(),
                              labelStyle: TextStyle(fontSize: 14.sp),
                              hintText: 'YYYY-MM-DD',
                              hintStyle: TextStyle(
                                  color: Color(0xffc1c1c1), fontSize: 12.sp),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            format: DateFormat("yyyy-MM-dd","en_US"),
                            onShowPicker: (context, currentValue) async {
                              return widget.benefit.mustMatch
                                  ? null
                                  : showDatePicker(
                                      context: context,
                                      firstDate: _cubit.benefit.benefitType ==
                                              AppStrings.group.tr()
                                          ? DateTime.now()
                                              .add(Duration(days: 7))
                                          : DateTime.now()
                                              .add(Duration(days: 1)),
                                      initialDate: _cubit.start,
                                      lastDate:
                                          DateTime(DateTime.now().year + 1)
                                              .add(Duration(days: -1)));
                            },
                            onChanged: _cubit.changeStartDate,
                            //initialValue:DateTime.now()
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          if (_cubit.benefit.requiredDocumentsArray != null)
                            SizedBox(
                              height: 120.h,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (_, index) {
                                    return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w),
                                        child: _cubit.myDocs.values
                                                    .elementAt(index) ==
                                                null
                                            ? SizedBox(
                                                height: 120.h,
                                                width: 120.h,
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    side: BorderSide(
                                                        color: redColor,
                                                        width: 2),
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                  ),
                                                  onPressed: () async {
                                                    _cubit.pickImage(_cubit
                                                        .myDocs.keys
                                                        .elementAt(index));
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        _cubit.myDocs.keys
                                                            .elementAt(index),
                                                        style: TextStyle(
                                                          color: redColor,
                                                          fontSize: 13.sp,
                                                          fontFamily: "Roboto",
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 3,
                                                        softWrap: true,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                      SizedBox(
                                                        width: 5.0.w,
                                                      ),
                                                      Icon(
                                                        CustomIcons
                                                            .cloud_upload__2_,
                                                        size: 30.r,
                                                        color: redColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Stack(
                                                fit: StackFit.loose,
                                                children: <Widget>[
                                                    Image(
                                                      image: MemoryImage(
                                                          base64Decode(_cubit
                                                              .myDocs.values
                                                              .elementAt(
                                                                  index)!)),
                                                      fit: BoxFit.fill,
                                                      width: 120.h,
                                                      height: 120.h,
                                                      gaplessPlayback: true,
                                                    ),
                                                    Positioned(
                                                      right: 5,
                                                      top: 5,
                                                      child: Container(
                                                        width: 25,
                                                        height: 25,
                                                        child: IconButton(
                                                          iconSize: 20,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          icon: Icon(
                                                            Icons.remove_circle,
                                                            size: 20,
                                                            color: Colors.red,
                                                          ),
                                                          onPressed: () {
                                                            _cubit.removeImage(
                                                                index);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ]));
                                  },
                                  itemCount: _cubit.myDocs.length),
                            ),

                          if (_cubit.missingDocs != null)
                            Text(
                              _cubit.missingDocs!,
                              style: TextStyle(color: redColor,fontSize: 12.sp),
                            ),

                          SizedBox(
                            height: 20.h,
                          ),
                          Center(
                            child: SizedBox(
                              width: 187.w,
                              height: 40.h,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if ((_formKey.currentState!.validate() &
                                        _cubit.validateParticipants() &
                                        _cubit.validateDocuments())) {
                                      _cubit.redeemCard();
                                    }
                                  },
                                  child: Text(AppStrings.redeem.tr(),
                                      style: TextStyle(fontSize: 12.sp))),
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
      },
    );
  }
}

class AppProfile {
  final String name;
  final String email;
  final String imageUrl;

  const AppProfile(this.name, this.email, this.imageUrl);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppProfile &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }
}
