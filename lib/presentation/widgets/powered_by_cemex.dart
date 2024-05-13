import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PoweredByCemex extends StatelessWidget {
  const PoweredByCemex({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Powered by",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontFamily: "Roboto",
          ),
        ),
        Image.asset(
          'assets/images/cemex.jpg',
          width: 80.w,
          height: 35.h,
          fit: BoxFit.fitWidth,
        )
      ],
    );
  }
}
