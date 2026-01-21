import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/storage/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../notification_service.dart';

class Global {
  static Future onInit() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); // device orientation control as portrait
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(statusBarColor: Config.appBarColor),
    // );
    await Firebase.initializeApp();
    await Get.putAsync<StorageService>(() => StorageService().init());
    Get.put<UserStore>(UserStore());
    await NotificationService().init();
  }
}

const String storageAccessToken = "myEventJar_accessToken";
const String storageRefreshToken = "myEventJar_refreshToken";
const String storageProfile = "myEventJar_profile";
const String storageFcmToken = "myEventJar_fcmToken";
String backendBaseUrl() {
  return "https://myeventjar.com/api";
} //Base url for Api request
