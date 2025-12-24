import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:eventjar/model/contact/contact_ui_model.dart';
import 'package:eventjar/page/contact/radial_design/contact_card_popup.dart';
import 'package:flutter/material.dart';

enum ContactCardAction { edit, delete }

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
  PieChartStageDefinition(name: "NEW CONTACT", color: Color(0xFF4DD0E1)),
  PieChartStageDefinition(name: "24H FOLLOWUP", color: Color(0xFFFF9800)),
  PieChartStageDefinition(name: "7D FOLLOWUP", color: Color(0xFF7C4DFF)),
  PieChartStageDefinition(name: "30D FOLLOWUP", color: Color(0xFF2196F3)),
  PieChartStageDefinition(name: "QUALIFIED LEAD", color: Color(0xFF66BB6A)),
];

void handleContactCardAction(
  BuildContext context,
  ContactCardAction action,
  Contact contact,
  ContactController controller,
) {
  if (action == ContactCardAction.edit) {
    controller.navigateToUpdateContact(contact);
  } else {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ContactCardDeletePopup(
        contactName: contact.name,
        onDelete: () => controller.deleteContactCard(contact.id),
      ),
    );
  }
}
