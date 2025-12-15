import 'package:get/get.dart';

class MyQrScreenState {
  RxBool isLoading = false.obs;
  final RxBool isSharing = false.obs;

  final myContact = <String, dynamic>{}.obs;
}
