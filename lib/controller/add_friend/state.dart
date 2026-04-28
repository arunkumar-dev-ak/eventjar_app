import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:get/get.dart';

enum AddFriendType { contact, newFriend }

class AddFriendState {
  final RxBool isLoading = false.obs;

  final Rxn<AddFriendType> selectedType = Rxn<AddFriendType>();

  RxList<MobileContact> contacts = <MobileContact>[].obs;
  Rxn<MobileContact> selectedContact = Rxn<MobileContact>();
  RxBool isContactDropdownLoading = false.obs;
  RxBool isContactDropdownLoadMoreLoading = false.obs;

  final RxBool sendViaEmail = false.obs;
  final RxBool sendViaPhone = false.obs;
}
