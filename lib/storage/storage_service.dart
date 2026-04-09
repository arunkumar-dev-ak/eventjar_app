import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find<StorageService>();
  // late final SharedPreferences _prefs;

  late final FlutterSecureStorage _storage;

  Future<StorageService> init() async {
    _storage = const FlutterSecureStorage();
    return this;
  }

  //set
  Future<void> setString(String key, String value) async {
    return await _storage.write(key: key, value: value);
  }

  //get
  Future<String?> getString(String key) async {
    return await _storage.read(key: key);
  }

  //delete
  Future<void> deleteString(String key) async {
    return await _storage.delete(key: key);
  }
}
