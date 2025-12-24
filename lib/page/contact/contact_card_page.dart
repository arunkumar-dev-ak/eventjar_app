import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/contact_ui_model.dart';
import 'package:eventjar/page/contact/contact_card_empty_page.dart';
import 'package:eventjar/page/contact/contact_card_shimmer.dart';
import 'package:eventjar/page/contact/radial_design/accordion_card.dart';
import 'package:eventjar/page/contact/radial_design/radial_design_func.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactCardPage extends StatelessWidget {
  ContactCardPage({super.key});

  final ContactController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ✅ Outer Obx
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
      }

      final contacts = controller.state.contacts;
      final expandedIndex = controller.state.expandedIndex.value;
      final screenWidth = MediaQuery.of(context).size.width;
      final isSmallScreen = screenWidth < 360;

      return Container(
        width: 100.wp,
        height: 100.hp,
        color: Colors.grey.shade200,

        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            final isExpanded = expandedIndex == index;

            return radialDesignBuildAccordionCard(
              contact: contact,
              stages: _buildStagesForContact(contact.stage.index),
              isSmallScreen: isSmallScreen,
              index: index,
              isExpanded: isExpanded,
              onToggleExpand: (int val) {
                controller.state.expandedIndex.value = val;
              },
              onCall: () {},
            );
          },
        ),
      );
    });
  }
}

List<PieChartModel> _buildStagesForContact(int activeStageIndex) {
  return stageDefinitions.asMap().entries.map((entry) {
    final index = entry.key;
    final stage = entry.value;
    final isEnabled = index <= activeStageIndex;
    return PieChartModel(
      name: stage.name,
      color: isEnabled ? stage.color : Colors.grey.shade400,
      isEnabled: isEnabled,
    );
  }).toList();
}
