import 'package:flutter/services.dart';

class Global {
  static Future init() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); // device orientation control as portrait
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(statusBarColor: Config.appBarColor),
    // );
    // await Get.putAsync<StorageService>(() => StorageService().init());
    // Get.put<UserStore>(UserStore());
  }
}

const String storageUserTokenkey = "user_token"; //key to store in localStorage
const String storageUserProfilekey =
    "user_profile"; //key to store in localStorage
const String storageUserCompanyNamekey =
    "client_company"; //key to store in localStorage
const String storageUserSalutationKey =
    "user_salutation"; //key to store in localStorage
const String storageUserPreviousDomainKey = "previous_domain_key";
const domainValidateUrl = "https://wheeldemo.humbletree.net/api/v1";
String url() {
  return "https://myeventjar.com/api";
} //Base url for Api request
