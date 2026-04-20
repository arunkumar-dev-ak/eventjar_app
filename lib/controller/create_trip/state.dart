import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:get/get.dart';

class CreateTripState {
  // Loading
  final RxBool isLoading = false.obs;

  // Contacts (for dropdown)
  final RxList<MobileContact> contacts = <MobileContact>[].obs;

  // Selected Friends (MULTI SELECT)
  final RxMap<String, MobileContact> selectedFriendsMap =
      <String, MobileContact>{}.obs;

  // Dropdown Loading
  final RxBool isDropdownLoading = false.obs;
  final RxBool isDropdownLoadMoreLoading = false.obs;

  // Pagination
  int page = 1;
  bool hasMore = true;

  // Search
  final RxString searchQuery = "".obs;
}
