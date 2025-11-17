import 'package:get/get.dart';

class ContactState {
  final RxBool isLoading = false.obs;

  RxBool showFilterRow = false.obs;
  var selectedTab = Rx<dynamic>(null);
}
