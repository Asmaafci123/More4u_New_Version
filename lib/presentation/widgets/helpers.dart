import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:more4u/core/constants/constants.dart';
import '../../core/firebase/push_notification_service.dart';
import '../../data/datasources/local_data_source/secure_local_data_source.dart';
import '../Login/login_screen.dart';
import '../notification/cubits/notification_cubit.dart';

Color getBenefitStatusColor(String status) {
  switch (status) {
    case 'Pending':
      return Colors.indigo;
    case 'InProgress':
      return yellowColor;
    case 'Approved':
      return greenColor;

    default:
      return redColor;
  }
}

Uint8List decodeImage(String imageBase64) {
  try {
    return base64Decode(imageBase64);
  } catch (error) {
    return Uint8List(0);
  }
}

void logOut(BuildContext context) {
  NotificationCubit.get(context).notifications.clear();
  PushNotificationService.deleteDeviceToken();
  final secureStorage=SecureStorageImpl();
  secureStorage.deleteSecureData('user id');
  secureStorage.deleteSecureData('user accessToken');
  secureStorage.deleteSecureData('user refreshToken');
  Navigator.of(context).pushNamedAndRemoveUntil(
      LoginScreen.routeName, (Route<dynamic> route) => false);
}
