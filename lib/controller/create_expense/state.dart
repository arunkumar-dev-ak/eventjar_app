import 'package:eventjar/model/budget_track/drop_down_response_model.dart';
import 'package:eventjar/model/meta/mobile_meta_model.dart';
import 'package:get/get.dart';

class CreateExpenseState {
  final RxBool isLoading = false.obs;

  final RxString title = ''.obs;
  final RxString amount = ''.obs;
  final RxString description = ''.obs;

  final List<String> categories = [
    "Accommodation",
    "Transportation",
    "Food & Drinks",
    "Activities",
    "Tickets",
    "Shopping",
    "Other",
  ];

  final Rxn<String> selectedCategory = Rxn("Shopping");

  // Updated to use the new model
  final RxList<DropdownMemberModel> members = <DropdownMemberModel>[].obs;
  final Rx<MobileMeta?> meta = Rxn<MobileMeta>();

  // Paid By (Single Select)
  final Rxn<DropdownMemberModel> paidBy = Rxn<DropdownMemberModel>();

  // Split With (Multi Select)
  final RxMap<String, DropdownMemberModel> selectedMembers =
      <String, DropdownMemberModel>{}.obs;

  final RxBool isMembersLoading = false.obs;
  final RxBool isMembersLoadMoreLoading = false.obs;
}
