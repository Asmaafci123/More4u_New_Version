import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../home/home_screen.dart';
class AppRoutScreen extends StatelessWidget {
  static const routeName = ' AppRoutScreen';
  const AppRoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(child: Text("Rout"),),
          SizedBox(
            height: 55.h,
          ),
          SizedBox(
            height: 50.h,
            width: 200.w,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    HomeScreen.routeName, (Route<dynamic> route) => false);
              },
              child: Text(
                "Go To Benefits",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
