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
      title: "Please wait",
      message: "Another contact is currently being saved",
    );
    return;
  }

  try {
    final granted = await FlutterContacts.requestPermission();
    if (!granted) {
      AppToast.warning('Contacts permission required to save contact');
      return;
    }

    controller.state.savingContact.value = contact;

    final alreadyExists = await contactAlreadyExists(contact);

    if (alreadyExists) {
      AppSnackbar.warning(
        title: "Already exists",
        message: "Contact already saved on this phone",
      );
      return;
    }

    final tags = contact.tags;
    final tagsText = tags.isNotEmpty ? tags.join(', ') : 'Saved from EventJar';

    String displayName = contact.name;
    if (tags.isNotEmpty) {
      final twoTags = tags.take(2).join(', ');
      displayName = '${contact.name} ($twoTags)';
    }

    final newContact = Contact()
      ..name.first = displayName
      ..notes = [Note(tagsText)];

    if (contact.phoneParsed?.fullNumber.isNotEmpty == true) {
      newContact.phones = [Phone(contact.phoneParsed!.fullNumber)];
    }

    if (contact.email.isNotEmpty) {
      newContact.emails = [Email(contact.email)];
    }

    if (contact.company != null || contact.position != null) {
      newContact.organizations = [
        Organization(
          company: contact.company ?? '',
          title: contact.position ?? '',
        ),
      ];
    }

    await FlutterContacts.insertContact(newContact);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${contact.name} saved successfully ✅'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  } catch (e, s) {
    LoggerService.loggerInstance.dynamic_d('$e\n$s');

    if (context.mounted) {
      AppSnackbar.error(title: "Failed", message: "Could not save contact");
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

  final contacts = await FlutterContacts.getContacts(withProperties: true);

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
