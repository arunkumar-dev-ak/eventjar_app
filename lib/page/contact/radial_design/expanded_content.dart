import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:eventjar/model/contact/contact_ui_model.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/page/contact/radial_design/circular_pie_chart_painter.dart';
import 'package:eventjar/page/contact/radial_design/next_stage_action_button.dart';
import 'package:eventjar/page/contact/radial_design/radial_design_func.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildExpandedContent(
  MobileContact contact,
  List<PieChartModel> stages,
  double chartSize,
  Color stageColor,
  int activeStageIndex,
  bool isSmallScreen,
) {
  final adjustedChartSize = isSmallScreen ? 250.0 : 270.0;

  return Container(
    padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
    child: Column(
      children: [
        SizedBox(height: 1.hp),
        // Divider(color: Colors.grey.shade200),
        SizedBox(
          width: adjustedChartSize,
          height: adjustedChartSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pie Chart (background)
              CustomPaint(
                size: Size(adjustedChartSize, adjustedChartSize),
                painter: CircularPieChartPainter(
                  stages: stages,
                  animationValue: 1.0,
                  showText: true,
                  activeStageIndex: contact.stage.index,
                ),
              ),

              // Center Button
              if (contact.stage.index < 4) // Not qualified
                GestureDetector(
                  onTap: () => _showTransitionDialog(contact: contact),
                  child: Container(
                    width: adjustedChartSize * 0.38,
                    height: adjustedChartSize * 0.38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: stageDefinitions[contact.stage.index].color
                              .withAlpha(40),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                      border: Border.all(
                        color: stageDefinitions[contact.stage.index].color
                            .withAlpha(80),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app,
                          size: isSmallScreen ? 18 : 22,
                          color: stageDefinitions[contact.stage.index].color,
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Tap for",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 6 : 7,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          "Next Stage",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 7 : 8,
                            fontWeight: FontWeight.w700,
                            color: stageDefinitions[contact.stage.index].color,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else // Qualified Stage (index == 4)
                Container(
                  width: adjustedChartSize * 0.38,
                  height: adjustedChartSize * 0.38,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      // ✅ Green gradient
                      colors: [
                        Colors.green.shade400,
                        Colors.green.shade600,
                        Colors.green.shade700,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withAlpha(60),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified,
                        size: isSmallScreen ? 22 : 26,
                        color: Colors.white,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Qualified", // ✅ Success message
                        style: TextStyle(
                          fontSize: isSmallScreen ? 9 : 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        SizedBox(height: 3.hp),

        //timeline
        _buildNextActionRow(
          stageColor,
          activeStageIndex,
          contact.stage,
          contact,
        ),

        SizedBox(height: 1.hp),
      ],
    ),
  );
}

Widget _buildNextActionRow(
  Color stageColor,
  int activeStageIndex,
  ContactStage currentStage,
  MobileContact contact,
) {
  final isLastStage = activeStageIndex == stageDefinitions.length - 1;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Row(
      children: [
        Expanded(
          child: _buildStageChip(
            stageColor: stageColor,
            label: stageDefinitions[activeStageIndex].fullName,
            icon: Icons.check_circle,
            isActive: true,
          ),
        ),

        if (!isLastStage) ...[
          SizedBox(width: 12),

          SizedBox(
            width: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Line
                Container(height: 2, color: Colors.grey.shade300),
                // Button ON TOP
                NextStageActionButton(
                  currentStage: currentStage,
                  contact: contact,
                ),
              ],
            ),
          ),

          SizedBox(width: 12),

          Expanded(
            child: _buildStageChip(
              stageColor: Colors.grey,
              label: stageDefinitions[activeStageIndex + 1].fullName,
              icon: null,
              isActive: false,
            ),
          ),
        ],

        if (isLastStage) ...[
          SizedBox(width: 12),
          Container(height: 2, width: 30, color: Colors.green.shade300),
          SizedBox(width: 8),
          Expanded(child: _buildCompletedChip()),
        ],
      ],
    ),
  );
}

Widget _buildStageChip({
  required Color stageColor,
  required String label,
  IconData? icon,
  required bool isActive,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      gradient: isActive
          ? LinearGradient(
              colors: [
                stageColor.withValues(alpha: 0.2),
                stageColor.withValues(alpha: 0.1),
              ],
            )
          : null,
      color: isActive ? null : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isActive
            ? stageColor.withValues(alpha: 0.4)
            : Colors.grey.shade300,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 12, color: stageColor),
          SizedBox(width: 3),
        ],
        // ✅ SINGLE Flexible for entire content
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? stageColor : Colors.grey.shade700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

// Completed chip
Widget _buildCompletedChip() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.green.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.verified, size: 14, color: Colors.green),
        SizedBox(width: 4),
        Flexible(
          child: Text(
            "Completed",
            style: TextStyle(
              fontSize: 11,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

void _showTransitionDialog({required MobileContact contact}) {
  final ContactController controller = Get.find();
  final currentStage = contact.stage;
  switch (currentStage) {
    case ContactStage.newContact:
      controller.navigateToThankyouMessage(contact);
      break;
    case ContactStage.followup24h:
    case ContactStage.followup7d:
      controller.navigateToScheduleMeeting(contact);
      break;
    case ContactStage.followup30d:
      controller.navigateToQualifyLead(contact);
      break;
    default:
      break;
  }
}
