import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more4u/core/constants/app_strings.dart';
import 'package:more4u/core/constants/constants.dart';

import '../../../custom_icons.dart';

showDetailsDialog({
  required BuildContext context,
  String? title,
  String? address,
  String? telephoneandmobile,
  String? workinghours,
  required bool isSucceeded,
  VoidCallback? onPressedOk,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0.r)),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                height: 450.w,
                width: 372.w,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.w, 30.h, 10.w, 20.h),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          title??'',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                              color: mainColor,
                          ),
                          textAlign:TextAlign.center,
                          maxLines: 4,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(CustomIcons.address_book,color: mainColor,),
                                    SizedBox(
                                      width: 10.h,
                                    ),
                                    Text(
                                      AppStrings.address.tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontFamily: 'Roboto',
                                          color: mainColor,
                                        fontWeight: FontWeight.w700,),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 3,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                AutoSizeText(
                                  address??'',
                                  style: TextStyle(fontSize: 18.sp,fontFamily: 'Roboto'),
                                  maxLines: 4,
                                ),
                              ],
                            ),
                            SizedBox(
                              height:10.h,
                            ),
                            Container(
                              width: 100.w,
                              height: 0.5.h,
                              color: greyColor,
                            ),
                            SizedBox(
                              height:10.h,
                            ),
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(CustomIcons.phone_call,color: mainColor,),
                                    SizedBox(
                                      width: 10.h,
                                    ),
                                    Text(
                                      AppStrings.telephoneAndMobile.tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18.sp,fontFamily: 'Roboto',color: mainColor, fontWeight: FontWeight.w700),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 3,
                                    ),
                                  ],
                                ),
                                AutoSizeText(
                                  telephoneandmobile??'',
                                  style: TextStyle(fontSize: 18.sp,fontFamily: 'Roboto'),
                                  maxLines: 4,
                                ),
                              ],
                            ),
                            SizedBox(
                              height:10.h,
                            ),
                            Container(
                              width: 100.w,
                              height: 0.5.h,
                              color: greyColor,
                            ),
                            SizedBox(
                              height:10.h,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(CustomIcons.clock,color: mainColor,),
                                    SizedBox(
                                      width: 10.h,
                                    ),
                                    Text(
                                      AppStrings.workingHours.tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18.sp,fontFamily: 'Roboto',color: mainColor, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                AutoSizeText(
                                  workinghours??'',
                                  style: TextStyle(fontSize: 18.sp,fontFamily: 'Roboto'),
                                  maxLines: 4,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: ()
                          {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 100.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: redColor,
                            ),
                            child: Center(
                              child: Text(AppStrings.close.tr(),style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp
                              ),),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),

            ],
          ));
    },
  );
}
