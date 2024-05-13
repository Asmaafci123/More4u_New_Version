import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/bloc_observer.dart';
import 'core/utils/env.dart';
import 'core/utils/services/local_storage/local_storage_service.dart';
import 'injection_container.dart' as di;
import 'myApp.dart';
import 'dart:io';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await di.init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await loadEnvFile('assets/env/.env_dev');
  BlocOverrides.runZoned(
        () {
      runApp(
          EasyLocalization(
              path: 'assets/langs',
              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
              ],
              fallbackLocale: const Locale('en'),
              startLocale: const Locale('en'),
              child: MyApp()));
    },
    blocObserver: MyBlocObserver(),
  );
  CacheHelper.init();

}