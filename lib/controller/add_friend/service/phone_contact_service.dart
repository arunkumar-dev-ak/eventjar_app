import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/logger_service.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

class PhoneContactResult {
  final String name;
  final String? phone;
  final String? email;

  PhoneContactResult({required this.name, this.phone, this.email});
}

class PhoneContactService {
  final RxBool isPickingContact = false.obs;

  Future<PhoneContactResult?> pickContact() async {
    try {
      isPickingContact.value = true;

      final status =
          await FlutterContacts.permissions.request(PermissionType.read);
      if (status != PermissionStatus.granted &&
          status != PermissionStatus.limited) {
        AppSnackbar.warning(
          title: 'permission_required'.tr,
          message: 'contacts_permission_required'.tr,
        );
        return null;
      }

      final contact = await FlutterContacts.native.showPicker(
        properties: {
          ContactProperty.phone,
          ContactProperty.email,
          ContactProperty.name,
        },
      );
      if (contact == null) return null;

      final name = contact.displayName ?? '';
      final phone =
          contact.phones.isNotEmpty ? contact.phones.first.number : null;
      final email = contact.emails.isNotEmpty
          ? contact.emails.first.address
          : null;

      return PhoneContactResult(name: name, phone: phone, email: email);
    } catch (e, s) {
      LoggerService.loggerInstance.e('Pick contact error: $e\n$s');
      AppSnackbar.error(
        title: 'error'.tr,
        message: 'failed_pick_contact'.tr,
      );
      return null;
    } finally {
      isPickingContact.value = false;
    }
  }
}
