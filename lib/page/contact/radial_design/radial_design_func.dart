import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/global/app_toast.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:eventjar/model/contact/contact_ui_model.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/page/contact/radial_design/contact_card_popup.dart';
import 'package:eventjar/page/contact/radial_design/contact_card_saving.dart';
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
      contactCardAddContactToPhone(context, contact);
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

// Future<void> _addContactToPhone(
//   BuildContext context,
//   MobileContact contact,
// ) async {
//   try {
//     // 🔐 Permission
//     final granted = await FlutterContacts.requestPermission();
//     if (!granted) {
//       AppToast.warning('Contacts permission required to save contact');
//       return;
//     }

//     // ⏳ SHOW LOADING
//     if (context.mounted) showLoadingSnackBar(context);

//     // final alreadyExists = await contactAlreadyExists(contact);
//     // if (alreadyExists) {
//     //   if (context.mounted) {
//     //     hideSnackBar(context);

//     //     ScaffoldMessenger.of(context).showSnackBar(
//     //       const SnackBar(
//     //         content: Text('Contact already exists in phone 📱'),
//     //         backgroundColor: Colors.orange,
//     //         behavior: SnackBarBehavior.floating,
//     //       ),
//     //     );
//     //   }
//     //   return;
//     // }

//     // final tags = contact.tags;

//     // final String tagsText = (tags.isNotEmpty)
//     //     ? tags.join(', ')
//     //     : 'Saved from EventJar';

//     // String displayName = contact.name;
//     // if (tags.isNotEmpty) {
//     //   final twoTags = tags.take(2).join(', ');
//     //   displayName = '${contact.name} ($twoTags)';
//     // }

//     // final newContact = Contact()
//     //   ..name.first = displayName
//     //   ..notes = [Note(tagsText)];

//     // if (contact.phoneParsed != null &&
//     //     contact.phoneParsed!.fullNumber.isNotEmpty) {
//     //   newContact.phones = [Phone(contact.phoneParsed!.fullNumber)];
//     // } else if (contact.phone != null && contact.phone!.isNotEmpty) {
//     //   newContact.phones = [Phone(contact.phone!)];
//     // }

//     // if (contact.email.isNotEmpty) {
//     //   newContact.emails = [Email(contact.email)];
//     // }

//     // if (contact.company != null || contact.position != null) {
//     //   newContact.organizations = [
//     //     Organization(
//     //       company: contact.company ?? '',
//     //       title: contact.position ?? '',
//     //     ),
//     //   ];
//     // }

//     // await FlutterContacts.insertContact(newContact);

//     // if (context.mounted) {
//     //   hideSnackBar(context);

//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //     SnackBar(
//     //       content: Text('${contact.name} added to phone contacts ✅'),
//     //       backgroundColor: Colors.green,
//     //       behavior: SnackBarBehavior.floating,
//     //     ),
//     //   );
//     // }
//   } catch (e, s) {
//     LoggerService.loggerInstance.dynamic_d('$e\n$s');

//     if (context.mounted) {
//       hideSnackBar(context);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Failed to save contact. Please try again.'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }
// }

// Future<bool> contactAlreadyExists(MobileContact contact) async {
//   final fullNumber = contact.phoneParsed?.fullNumber;

//   if (fullNumber == null || fullNumber.isEmpty) {
//     return false;
//   }

//   String normalize(String number) {
//     return number.replaceAll(RegExp(r'\D'), '');
//   }

//   final newNumber = normalize(fullNumber);

//   final contacts = await FlutterContacts.getContacts(withProperties: true);

//   for (final c in contacts) {
//     for (final p in c.phones) {
//       final existing = normalize(p.number);

//       if (existing == newNumber) {
//         return true;
//       }
//     }
//   }

//   return false;
// }

// void showLoadingSnackBar(BuildContext context) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       duration: const Duration(days: 1),
//       behavior: SnackBarBehavior.floating,
//       backgroundColor: Colors.blueGrey.shade900, // 🎨 Background color
//       elevation: 6,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16), // rounded corners
//       ),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       content: Row(
//         children: const [
//           SizedBox(
//             height: 20,
//             width: 20,
//             child: CircularProgressIndicator(
//               strokeWidth: 2.5,
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//             ),
//           ),
//           SizedBox(width: 14),
//           Expanded(
//             child: Text(
//               'Saving contact...',
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// void hideSnackBar(BuildContext context) {
//   ScaffoldMessenger.of(context).hideCurrentSnackBar();
// }
