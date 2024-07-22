import 'package:flutter/material.dart';

class Constants {
  // App Settings
  static const String appName = "Universal Webview";
  static const String baseUrl = "https://www.google.co.in/";
  static const String appVersion = "1.0.0";
  static const String splashSubTitle = "MORE IDEAS FOR YOUR NIVESH";
  static const int splashDurationSeconds = 3;

  // URL Schemes
  static const String whatsappUrlScheme = "whatsapp";
  static const String whatsappUrlWame = "https://wa.me/";
  static const String whatsappUrlApi = 'https://api.whatsapp.com/';
  static const String telegramUrlScheme = "tg";
  static const String telegramTMe = 'https://t.me/';
  static const String facebookUrl = "facebook.com";
  static const String facebookUrlfbCom = "fb.com";

  static const List<String> otherUrlMatchers = [
    'http',
    'https',
    'file',
    'chrome',
    'data',
    'javascript',
    'about',
  ];

  // IMAGES
  static const String logoImagePath = "assets/images/logo.png";

  // Colors
  static const Color appThemeColor = Color(0xff0080CE);
  static const Color splashVersionNumberColor = Color(0xff5D18EB);
  static const Color splashSubTitleColor = Color(0xff5D18EB);

  // Notification Config
  static const String notificationIconImage = "@mipmap/ic_launcher";
  static const String notificationChannelId = "all_news";
  static const String notificationChannelName = "All Notifications";
}
