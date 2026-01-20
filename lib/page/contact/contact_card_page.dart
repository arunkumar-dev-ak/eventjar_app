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
      final screenWidth = MediaQuery.of(context).size.width;
      final isSmallScreen = screenWidth < 360;

      return Stack(
        children: [
          IgnorePointer(
            ignoring: controller.state.isSearching.value,
            child: controller.state.isLoading.value
                ? ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return buildShimmerPlaceholderForContactCard();
                    },
                  )
                : controller.state.contacts.isEmpty
                ? buildEmptyStateForContact()
                : Container(
                    width: 100.wp,
                    height: 100.hp,
                    color: Colors.grey.shade200,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      itemCount: controller.state.contacts.length + 1,
                      itemBuilder: (context, index) {
                        if (index == controller.state.contacts.length + 1) {
                          return buildShimmerPlaceholderForContactCard();
                        }

                        final contact = controller.state.contacts[index];
                        final isExpanded =
                            controller.state.expandedIndex.value == index;

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
                  ),
          ),

          if (controller.state.isSearching.value)
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100, // Light grey background
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Circular loader
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(
                          Colors.grey.shade700,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // Processing text
                    Text(
                      "Processing...",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
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
