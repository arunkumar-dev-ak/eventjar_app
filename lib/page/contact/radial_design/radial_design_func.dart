import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/global/app_toast.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:eventjar/model/contact/contact_ui_model.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/page/contact/radial_design/contact_card_popup.dart';
import 'package:eventjar/page/contact/radial_design/invite_to_eventjar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

enum ContactCardAction {
  edit,
  delete,
  call,
  mail,
  addToPhone,
  inviteToEventJar,
}

int getStageIndexFromContact(ContactStage stage) {
  switch (stage) {
    case ContactStage.newContact:
      return 0;
    case ContactStage.followup24h:
      return 1;
    case ContactStage.followup7d:
      return 2;
    case ContactStage.followup30d:
      return 3;
    case ContactStage.qualified:
      return 4;
  }
}

final List<PieChartStageDefinition> stageDefinitions = [
  PieChartStageDefinition(
    name: "NEW CONTACT",
    color: Color(0xFF4DD0E1),
    fullName: "NEW CONTACT",
  ),
  PieChartStageDefinition(
    name: "24H FOLLOWUP",
    color: Color(0xFFFF9800),
    fullName: "24 HOUR FOLLOWUP",
  ),
  PieChartStageDefinition(
    name: "7D FOLLOWUP",
    color: Color(0xFF7C4DFF),
    fullName: "7 DAY FOLLOWUP",
  ),
  PieChartStageDefinition(
    name: "30D FOLLOWUP",
    color: Color(0xFF2196F3),
    fullName: "30 DAY FOLLOWUP",
  ),
  PieChartStageDefinition(
    name: "QUALIFIED LEAD",
    color: Color(0xFF66BB6A),
    fullName: "QUALIFIED LEAD",
  ),
];

void handleContactCardAction(
  BuildContext context,
  ContactCardAction action,
  MobileContact contact,
  ContactController controller,
) {
  switch (action) {
    case ContactCardAction.edit:
      controller.navigateToUpdateContact(contact);
      break;

    case ContactCardAction.addToPhone:
      _addContactToPhone(context, contact);
      break;

    case ContactCardAction.delete:
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ContactCardDeletePopup(
          contactName: contact.name,
          onDelete: () => controller.deleteContactCard(contact.id),
        ),
      );
      break;

    case ContactCardAction.mail:
      if (contact.email.isNotEmpty) {
        controller.launchEmail(contact.email);
      }
      break;

    case ContactCardAction.call:
      if (contact.phone != null) {
        controller.launchPhoneCall(contact.phone!);
      }
      break;

    case ContactCardAction.inviteToEventJar:
      final invitedUserName = UserStore.to.profile['name'] ?? "Someone";
      inviteToEventJarOnWhatsApp(
        phone: contact.phone,
        name: contact.name,
        invitedUserName: invitedUserName,
        context: context,
      );
      break;
  }
}

Future<void> _addContactToPhone(
  BuildContext context,
  MobileContact contact,
) async {
  try {
    // 🔐 Permission
    final granted = await FlutterContacts.requestPermission();
    if (!granted) {
      AppToast.warning('Contacts permission required to save contact');
      return;
    }

    LoggerService.loggerInstance.dynamic_d('Contacts permission granted');

    final tags = contact.tags;

    // 📱 Create device contact
    final String tagsText = (tags.isNotEmpty)
        ? tags.join(', ')
        : 'Saved from EventJar';

    // Add max 2 tags to name
    String displayName = contact.name;
    if (tags.isNotEmpty) {
      final twoTags = tags.take(2).join(', ');
      displayName = '${contact.name} ($twoTags)';
    }

    final newContact = Contact()
      ..name.first = displayName
      ..notes = [Note(tagsText)];

    // 📞 Phone
    if (contact.phoneParsed != null &&
        contact.phoneParsed!.fullNumber.isNotEmpty) {
      newContact.phones = [Phone(contact.phoneParsed!.fullNumber)];
    } else if (contact.phone != null && contact.phone!.isNotEmpty) {
      newContact.phones = [Phone(contact.phone!)];
    }

    // 📧 Email
    if (contact.email.isNotEmpty) {
      newContact.emails = [Email(contact.email)];
    }

    // 🏢 Company & Job Title
    if (contact.company != null || contact.position != null) {
      newContact.organizations = [
        Organization(
          company: contact.company ?? '',
          title: contact.position ?? '',
        ),
      ];
    }

    // 💾 Save contact
    await FlutterContacts.insertContact(newContact);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${contact.name} added to phone contacts ✅'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  } catch (e, s) {
    LoggerService.loggerInstance.dynamic_d('$e\n$s');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save contact. Please try again.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
