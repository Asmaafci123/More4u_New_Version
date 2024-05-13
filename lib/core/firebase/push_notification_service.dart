import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:more4u/data/datasources/remote_data_source.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';
import 'package:http/http.dart' as http;
import '../../presentation/home/home_screen.dart';
import '../../presentation/notification/notification_screen.dart';
import 'notifcation_service.dart';
class PushNotificationService {
  static init(context) async {
    await getDeviceToken();
    await subscribeToTopicAll();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        Navigator.pushNamed(context, NotificationScreen.routeName);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        HomeCubit.get(context).changeNotificationCount(
            HomeCubit.get(context).userUnSeenNotificationCount + 1);

        NotificationService notificationService = NotificationService();
        notificationService.initializeNotification();
        notificationService.notifun = () {
          if (ModalRoute.of(context)?.settings.name ==
              HomeScreen.routeName) {
            final completer = Completer();
            final result = Navigator.pushNamedAndRemoveUntil(
                context, NotificationScreen.routeName,
                ModalRoute.withName(HomeScreen.routeName)).whenComplete(() =>
                HomeCubit.get(context).getHomeData());
            completer.complete(result);
          } else{
            final completer = Completer();
            final result = Navigator.pushReplacementNamed(
                context, NotificationScreen.routeName,
                result: completer.future);
            completer.complete(result);
          }        };
        notificationService.displayNotification(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.pushNamedAndRemoveUntil(context, NotificationScreen.routeName, ModalRoute.withName(HomeScreen.routeName));
    });

    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
      _sendTokenToServer(fcmToken);
    });
  }

  static getDeviceToken() async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    if(deviceToken!=null) {
      _sendTokenToServer(deviceToken);
    }
    return deviceToken;
  }

  static subscribeToTopicAll() async {
    await FirebaseMessaging.instance.subscribeToTopic('all');
  }

  static unsubscribeFromTopicAll() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic('all');
  }

  static deleteDeviceToken() async {
    await unsubscribeFromTopicAll();
    await FirebaseMessaging.instance.deleteToken();
  }

  static _sendTokenToServer(String tokenFirebase) {
    RemoteDataSource remoteDataSource =
        RemoteDataSourceImpl(client: http.Client());
    remoteDataSource
        .updateToken(userNumber:userNumber!, token: tokenFirebase,userToken:accessToken,languageCode: languageId??1)
        .then((value) => {});
  }
}
