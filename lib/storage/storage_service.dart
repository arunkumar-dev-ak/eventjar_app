import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find<StorageService>();
  late final SharedPreferences _prefs;
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  //set
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  //get
  Future<String?> getString(String key) async {
    return _prefs.getString(key) ?? "";
  }

  //delete
  Future<bool> deleteString(String key) async {
    return await _prefs.remove(key);
  }
}
