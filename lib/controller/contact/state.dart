import 'package:eventjar/model/contact/contact_analytics_model.dart';
// import 'package:eventjar/model/contact/contact_model.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/model/meta/meta_model.dart';
import 'package:get/get.dart';

class ContactState {
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  final RxBool isSearching = false.obs;
  final RxBool isFetching = false.obs;
  final RxBool isFetchingWhileScrolling = false.obs;

  RxBool showFilterRow = false.obs;
  Rx<NetworkStatusCardData?> selectedTab = Rx<NetworkStatusCardData?>(null);
  Rx<ContactAnalytics?> analytics = Rx<ContactAnalytics?>(null);

  RxList<MobileContact> contacts = <MobileContact>[].obs;

  RxInt expandedIndex = 0.obs;
  Rxn<Meta> meta = Rxn<Meta>();
}
