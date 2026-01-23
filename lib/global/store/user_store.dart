import 'dart:convert';

import 'package:eventjar/global/device_helper.dart';
import 'package:eventjar/global/global_values.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/auth/login_model.dart';
import 'package:eventjar/model/auth/refresh_token_model.dart';
import 'package:eventjar/storage/storage_service.dart';
import 'package:get/get.dart';

class UserStore extends GetxController {
  static UserStore get to => Get.find<UserStore>();

  final _isLogin = false.obs;
  final _accessToken = "".obs;
  final _refreshToken = "".obs;
  RxString _deviceId = ''.obs;
  final _profile = RxMap<String, dynamic>(); // Declare as RxMap

  bool get isLogin => _isLogin.value;
  RxBool get isLoginReactive => _isLogin;
  String get accessToken => _accessToken.value;
  String get refreshToken => _refreshToken.value;
  String get deviceId => _deviceId.value;
  Map<String, dynamic> get profile => _profile;

  // String get name {
  //   final String firstName = capitalize(
  //     UserStore.to.profile["first_name"] ?? "",
  //   );
  //   final String lastName = UserStore.to.profile["last_name"] ?? "";

  //   return "${firstName.isEmpty ? "--" : firstName} ${lastName.isEmpty ? "" : lastName}";
  // }

  @override
  void onInit() async {
    LoggerService.loggerInstance.dynamic_d("In UserStore");

    _accessToken.value =
        await StorageService.to.getString(storageAccessToken) ?? "";
    _refreshToken.value =
        await StorageService.to.getString(storageRefreshToken) ?? "";

    String? userProfile = await StorageService.to.getString(storageProfile);

    if (userProfile != null &&
        userProfile.isNotEmpty &&
        _accessToken.value.isNotEmpty &&
        _refreshToken.value.isNotEmpty) {
      // Decode and set profile
      var decodedProfile = jsonDecode(userProfile);
      _profile.value =
          decodedProfile; // Use _profile.value to set data in RxMap
      _isLogin.value = true; // Mark as logged in
    }

    _deviceId.value = await DeviceIdHelper.getDeviceId();
    await DeviceIdHelper.getDeviceId();

    super.onInit();
  }

  Future<void> handleSetLocalData(LoginResponse loginData) async {
    LoggerService.loggerInstance.dynamic_d(loginData);
    _isLogin.value = true;
    await setAccessToken(loginData.accessToken!);
    _accessToken.value = loginData.accessToken!;
    await setRefreshToken(loginData.refreshToken!);
    _refreshToken.value = loginData.refreshToken!;
    await setProfile(loginData.user!.toJson());
    _profile.value = loginData.user!.toJson();
  }

  Future<void> deleteAccessToken() async {
    await setAccessToken("");
    _accessToken.value = "";
  }

  Future<void> handleSetLocalDataForRefreshToken(
    RefreshTokenResponse loginData,
  ) async {
    LoggerService.loggerInstance.dynamic_d(loginData);
    _isLogin.value = true;
    await setAccessToken(loginData.accessToken);
    _accessToken.value = loginData.accessToken;
    await setRefreshToken(loginData.refreshToken);
    _refreshToken.value = loginData.refreshToken;
  }

  Future<void> setAccessToken(String accessToken) async {
    await StorageService.to.setString(storageAccessToken, accessToken);
  }

  Future<void> setRefreshToken(String refreshToken) async {
    await StorageService.to.setString(storageRefreshToken, refreshToken);
  }

  Future<void> updateAccessAndRefreshToken(
    String accessToken,
    String? refreshToken,
  ) async {
    LoggerService.loggerInstance.dynamic_d(accessToken);
    await setAccessToken(accessToken);
    _accessToken.value = accessToken;
    if (refreshToken != null) {
      await setRefreshToken(refreshToken);
      _refreshToken.value = refreshToken;
    }
  }

  Future<void> setProfile(Map<String, dynamic> profile) async {
    await StorageService.to.setString(storageProfile, jsonEncode(profile));
  }

  Future<void> clearStore() async {
    await StorageService.to.deleteString(storageAccessToken);
    await StorageService.to.deleteString(storageRefreshToken);
    await StorageService.to.deleteString(storageProfile);

    _isLogin.value = false;
    _accessToken.value = '';
    _refreshToken.value = '';
  }
}
