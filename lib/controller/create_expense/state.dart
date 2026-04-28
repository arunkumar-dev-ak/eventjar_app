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

  final RxList<String> members = <String>[
    "Arun",
    "Rahul",
    "Vignesh",
    "Karthik",
  ].obs;

  final RxMap<String, String> selectedMembers = <String, String>{}.obs;

  final RxBool isMembersLoading = false.obs;
  final RxBool isMembersLoadMoreLoading = false.obs;
}
