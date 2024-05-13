import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_strings.dart';

loadingAlertDialog(BuildContext context,{bool isDismissible=false}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            SizedBox(
              width: 4.w,
            ),
            Container(
              margin: EdgeInsets.only(left: 16.w),
              child: Text(AppStrings.loading.tr(),style: TextStyle(
                fontSize: 12.sp
              ),),
            ),
          ],
        ),
      );
    },
  );
}
