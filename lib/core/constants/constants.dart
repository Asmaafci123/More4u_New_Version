import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';
import '../utils/env.dart';



var scaffoldKey = GlobalKey<ScaffoldState>();
var homeKey = GlobalKey();

const Color mainColor = Color(0xFF182756);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color defaultColor = Color(0xFF212121);
const Color greyColor = Color(0xff6d6d6d);
const Color whiteGreyColor = Color(0xFFC1C1C1);
const Color redColor = Color(0xFFEA1C2D);
const Color yellowColor = Color(0xFFFFA115);
const Color greenColor = Color(0xff00ed51);

const appBarsTextStyle = TextStyle(
  color: Colors.white,
);


User? userData;
int? languageId=1;
String? accessToken;
String? refreshToken;
Map<String,String>?env;
int? userNumber;
bool isOffline=false;
