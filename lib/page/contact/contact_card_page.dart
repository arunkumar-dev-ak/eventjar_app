import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/page/contact/contact_card_empty_page.dart';
import 'package:eventjar/page/contact/contact_card_page_card.dart';
import 'package:eventjar/page/contact/contact_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactCardPage extends StatelessWidget {
  ContactCardPage({super.key});

  final ContactController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.isLoading.value) {
        return ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          itemCount: 3,
          itemBuilder: (context, index) {
            return buildShimmerPlaceholderForContactCard();
          },
        );
      } else if (controller.state.contacts.isEmpty) {
        return buildEmptyStateForContact();
      } else {
        final contacts = controller.state.contacts;
        return ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          itemCount: controller.state.contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];

            return ContactCard(contact: contact, index: index);
          },
        );
      }
    });
  }
}
