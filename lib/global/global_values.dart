import 'package:eventjar/global/store/language_store.dart';
import 'package:eventjar/global/store/theme_store.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/storage/storage_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Global {
  static Future onInit() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); // device orientation control as portrait
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(statusBarColor: Config.appBarColor),
    // );
    await Get.putAsync<StorageService>(() => StorageService().init());
    Get.put<UserStore>(UserStore());
    Get.put<ThemeStore>(ThemeStore());
    Get.put<LanguageStore>(LanguageStore());
    // Get.put<ToastController>(ToastController());
  }
}

const String storageAccessToken = "myEventJar_accessToken";
const String storageRefreshToken = "myEventJar_refreshToken";
const String storageProfile = "myEventJar_profile";
const String storageFcmToken = "myEventJar_fcmToken";
const String pkceCodeVerifier = "pkce_code_verifier";
const String storageLanguageCode = "myEventJar_languageCode";
const String storageLanguageSelected = "myEventJar_languageSelected";
const String supportWhatsAppNumber = "+919360659283";

String frontendBaseUrl() {
  return "https://myeventjar.com";
} //Base url for front end request

String backendBaseUrl() {
  //return "https://myeventjar.com/api";
  //return "http://10.0.2.2:4000/";
  return "https://darkroom-gizzard-tingle.ngrok-free.dev";
} //Base url for Api request
