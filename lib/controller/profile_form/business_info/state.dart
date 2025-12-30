import 'package:get/get.dart';

class BusinessInfoFormState {
  final RxBool isLoading = false.obs;

  RxString selectedCountryCode = '+91'.obs;
  RxString selectedBusinessCategory = ''.obs;
  RxList<String> selectedOperatingRegions = <String>[].obs;
}
