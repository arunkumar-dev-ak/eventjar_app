import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/app_toast.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

Future<void> contactCardAddContactToPhone(
  BuildContext context,
  MobileContact contact,
) async {
  final ContactController controller = Get.find();

  if (controller.state.isSavingContact.value) {
    AppSnackbar.warning(
      title: 'please_wait'.tr,
      message: 'another_contact_saving'.tr,
    );
    return;
  }

  try {
    final status =
        await FlutterContacts.permissions.request(PermissionType.readWrite);
    if (status != PermissionStatus.granted &&
        status != PermissionStatus.limited) {
      AppToast.warning('contacts_permission_required'.tr);
      return;
    }

    controller.state.savingContact.value = contact;

    final alreadyExists = await contactAlreadyExists(contact);

    if (alreadyExists) {
      AppSnackbar.warning(
        title: 'already_exists'.tr,
        message: 'contact_already_saved_phone'.tr,
      );
      return;
    }

    final tags = contact.tags;
    final tagsText = tags.isNotEmpty ? tags.join(', ') : 'saved_from_eventjar'.tr;

    String displayName = contact.name;
    if (tags.isNotEmpty) {
      final twoTags = tags.take(2).join(', ');
      displayName = '${contact.name} ($twoTags)';
    }

    final newContact = Contact(
      name: Name(first: displayName),
      notes: [Note(note: tagsText)],
      phones: contact.phoneParsed?.fullNumber.isNotEmpty == true
          ? [Phone(number: contact.phoneParsed!.fullNumber)]
          : [],
      emails: contact.email.isNotEmpty
          ? [Email(address: contact.email)]
          : [],
      organizations:
          (contact.company != null || contact.position != null)
              ? [
                  Organization(
                    name: contact.company ?? '',
                    jobTitle: contact.position ?? '',
                  ),
                ]
              : [],
    );

    await FlutterContacts.create(newContact);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${contact.name} saved successfully ✅'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  } catch (e, s) {
    LoggerService.loggerInstance.e('$e\n$s');

    if (context.mounted) {
      AppSnackbar.error(title: 'failed'.tr, message: 'could_not_save_contact'.tr);
    }
  } finally {
    controller.state.savingContact.value = null;
  }
}

Future<bool> contactAlreadyExists(MobileContact contact) async {
  final fullNumber = contact.phoneParsed?.fullNumber;

  if (fullNumber == null || fullNumber.isEmpty) {
    return false;
  }

  String normalize(String number) {
    return number.replaceAll(RegExp(r'\D'), '');
  }

  final newNumber = normalize(fullNumber);

  final contacts = await FlutterContacts.getAll(
    properties: {ContactProperty.phone},
  );

  for (final c in contacts) {
    for (final p in c.phones) {
      final existing = normalize(p.number);

      if (existing == newNumber) {
        return true;
      }
    }
  }

  return false;
}
