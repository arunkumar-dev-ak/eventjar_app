import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:eventjar/model/contact/contact_ui_model.dart';
import 'package:eventjar/page/contact/radial_design/contact_card_header.dart';
import 'package:eventjar/page/contact/radial_design/expanded_content.dart';
import 'package:eventjar/page/contact/radial_design/notes_section.dart';
import 'package:eventjar/page/contact/radial_design/radial_design_func.dart';
import 'package:flutter/material.dart';

Widget radialDesignBuildAccordionCard({
  required Contact contact,
  required List<PieChartModel> stages,
  required bool isSmallScreen,
  required int index,
  required bool isExpanded,
  required Function(int) onToggleExpand,
  required VoidCallback onCall,
}) {
  // Map ContactStage to stageDefinitions
  final int activeStageIndex = _getStageIndexFromContact(contact.stage);
  final Color stageColor = stageDefinitions[activeStageIndex].color;
  final expandedChartSize = isSmallScreen ? 200.0 : 240.0;

  return Container(
    margin: EdgeInsets.only(bottom: 1.5.hp),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isExpanded
            ? stageColor.withValues(alpha: 0.4)
            : Colors.transparent,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: isExpanded
              ? stageColor.withValues(alpha: 0.25)
              : Colors.grey.withValues(alpha: 0.15),
          blurRadius: isExpanded ? 25 : 12,
          offset: Offset(0, isExpanded ? 12 : 4),
          spreadRadius: isExpanded ? 2 : 0,
        ),
        if (isExpanded)
          BoxShadow(
            color: stageColor.withValues(alpha: 0.15),
            blurRadius: 40,
            offset: Offset(0, 8),
            spreadRadius: 5,
          ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          ContactCardHeader(
            isSmallScreen: isSmallScreen,
            index: index,
            isExpanded: isExpanded,
            contact: contact,
            stages: stages,
          ),
          AnimatedCrossFade(
            firstChild: SizedBox.shrink(),
            secondChild: buildExpandedContent(
              contact,
              stages,
              expandedChartSize,
              stageColor,
              activeStageIndex,
              isSmallScreen,
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
          ),
          if (isExpanded && contact.notes != null && contact.notes!.isNotEmpty)
            buildNotesSection(contact.notes!, stageColor),
        ],
      ),
    ),
  );
}

// Map ContactStage to stageDefinitions index
int _getStageIndexFromContact(ContactStage stage) {
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
