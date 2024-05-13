import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

myAppBar(String title) {
  if(defaultTargetPlatform==TargetPlatform.android)return null;
  else
    {
      return CupertinoNavigationBar(
        middle: Text(title, style: TextStyle(color: mainColor)),
        backgroundColor: Colors.grey.shade50,
      );
    }

}
myAppBarMedicalIos() {
  if(defaultTargetPlatform==TargetPlatform.android)return null;
  else
  {
    return CupertinoNavigationBar(
      middle: SizedBox(),
      backgroundColor: Colors.grey.shade50,
    );
  }

}