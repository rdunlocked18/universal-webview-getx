import 'package:universal_webview/app/data/constants.dart';
import 'package:universal_webview/app/data/firebase_notification_service.dart';
import 'package:universal_webview/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseNotificationService notificationService =
      FirebaseNotificationService();
  await notificationService.initialize();
  debugPrint(await notificationService.getToken());

  runApp(
    GetMaterialApp(
      title: Constants.appName,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
