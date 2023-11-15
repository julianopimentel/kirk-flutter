import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase/notification_utils.dart';

void setStatusBarColor() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.grey,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  ));
}

void initializeApp() {
  createNotificationChannels();
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
}
