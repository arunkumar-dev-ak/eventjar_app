import 'package:currency_picker/currency_picker.dart';
import 'package:eventjar/model/budget_track/split_track_friend_model.dart';
import 'package:get/get.dart';

class CreateTripState {
  final RxBool isLoading = false.obs;

  // Edit mode
  bool isEditMode = false;
  String? editTripId;

  // Friends (for dropdown)
  final RxList<SplitTrackFriend> friends = <SplitTrackFriend>[].obs;

  // Selected Friends (MULTI SELECT)
  final RxMap<String, SplitTrackFriend> selectedFriendsMap =
      <String, SplitTrackFriend>{}.obs;

  // Dropdown Loading
  final RxBool isDropdownLoading = false.obs;
  final RxBool isDropdownLoadMoreLoading = false.obs;

  // Pagination
  int page = 1;
  bool hasMore = true;

  // Search
  final RxString searchQuery = "".obs;

  // Currency
  final Rx<Currency> selectedCurrency = CurrencyService()
      .findByCode('INR')!
      .obs;
}
