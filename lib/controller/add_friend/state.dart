import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:get/get.dart';
import 'package:eventjar/model/meta/meta_model.dart';

enum AddFriendType { newFriend, contact, phoneContact }

class AddFriendState {
  final RxBool isLoading = false.obs;

  final RxBool hasValidEmail = false.obs;

  final Rxn<AddFriendType> selectedType = Rxn<AddFriendType>();

  Rx<Country> selectedCountry = countries
      .firstWhere((country) => country.code == 'IN')
      .obs;

  RxList<MobileContact> contacts = <MobileContact>[].obs;
  Rxn<MobileContact> selectedContact = Rxn<MobileContact>();
  RxBool isContactDropdownLoading = false.obs;
  RxBool isContactDropdownLoadMoreLoading = false.obs;

  Rxn<Meta> meta = Rxn<Meta>();

  RxBool get hasMoreContacts => (meta.value?.hasNext ?? false).obs;

  final RxBool sendViaEmail = false.obs;
  final RxBool sendViaPhone = false.obs;
}
