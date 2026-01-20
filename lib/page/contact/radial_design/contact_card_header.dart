import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/contact_ui_model.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/page/contact/radial_design/circular_pie_chart_painter.dart';
import 'package:eventjar/page/contact/radial_design/radial_design_func.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactCardHeader extends StatelessWidget {
  final bool isSmallScreen;
  final bool isExpanded;
  final MobileContact contact;
  final int index;
  final List<PieChartModel> stages;

  ContactCardHeader({
    super.key,
    required this.isSmallScreen,
    required this.index,
    required this.isExpanded,
    required this.contact,
    required this.stages,
  });

  final ContactController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final int activeStageIndex = getStageIndexFromContact(contact.stage);
    final Color stageColor = stageDefinitions[activeStageIndex].color;

    final collapsedChartSize = isSmallScreen ? 50.0 : 60.0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => {controller.state.expandedIndex.value = index},
        splashColor: stageColor.withValues(alpha: 0.3),
        highlightColor: stageColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Small Pie Chart
              if (!isExpanded) _buildSmallChart(stages, collapsedChartSize),

              if (!isExpanded) SizedBox(width: 3.wp),

              // Contact Info - Collapsed view
              if (!isExpanded)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNameWithCallButton(
                        name: contact.name,
                        contact: contact,
                        isExpanded: isExpanded,
                        controller: controller,
                        nameFontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 3),
                      _buildInfoRow(
                        Icons.email_outlined,
                        Colors.grey.shade600,
                        contact.email,
                      ),
                      if (contact.phone != null)
                        _buildInfoRow(
                          Icons.phone_outlined,
                          Colors.grey.shade600,
                          contact.phone ?? 'No phone',
                        ),
                      SizedBox(height: 12),
                      _buildStageBadge(stageColor, contact.stage.index),
                    ],
                  ),
                ),

              // Expanded Header (Current → Next Stage)
              if (isExpanded)
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            Text(
                              contact.name,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                            // Email
                            _buildInfoRow(
                              Icons.email_outlined,
                              Colors.grey.shade600,
                              contact.email,
                            ),

                            // Phone
                            if (contact.phone != null)
                              _buildInfoRow(
                                Icons.phone_rounded,
                                Colors.grey.shade600,
                                contact.phone!,
                              ),
                          ],
                        ),
                      ),
                      SizedBox(width: 2.wp),
                      PopupMenuButton<ContactCardAction>(
                        icon: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.more_vert,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: ContactCardAction.edit,
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Edit Contact',
                                  style: TextStyle(color: Colors.grey.shade800),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: ContactCardAction.delete,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Delete Contact',
                                  style: TextStyle(color: Colors.grey.shade800),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: ContactCardAction.mail,
                            child: Row(
                              children: [
                                Icon(Icons.email, color: Colors.blue, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Mail',
                                  style: TextStyle(color: Colors.grey.shade800),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: ContactCardAction.call,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: Colors.green,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Call',
                                  style: TextStyle(color: Colors.grey.shade800),
                                ),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (action) => {
                          handleContactCardAction(
                            context,
                            action,
                            contact,
                            controller,
                          ),
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/*----- Collapsed helper -----*/
//email,phone,name
Widget _buildInfoRow(IconData icon, Color iconColor, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Icon(icon, size: 14, color: iconColor),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 8.sp,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

//phone call
Widget _buildNameWithCallButton({
  required String name,
  required MobileContact contact,
  required bool isExpanded,
  required ContactController controller,
  FontWeight nameFontWeight = FontWeight.normal,
  double nameFontSize = 10.0,
  double callFontSize = 7.0,
}) {
  return Row(
    children: [
      Expanded(
        child: Text(
          name,
          style: TextStyle(
            fontSize: nameFontSize.sp,
            fontWeight: nameFontWeight,
            color: Colors.black87,
          ),
        ),
      ),
      SizedBox(width: 1.wp),
      GestureDetector(
        onTap: () async => {await controller.launchPhoneCall(contact.phone!)},
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.call, size: 14, color: Colors.green),
              SizedBox(width: 4),
              Text(
                "Call",
                style: TextStyle(
                  fontSize: callFontSize.sp,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

//stage badge
Widget _buildStageBadge(Color stageColor, int activeStageIndex) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: stageColor.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: stageColor.withValues(alpha: 0.3)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 10, color: stageColor),
        SizedBox(width: 6),
        Text(
          stageDefinitions[activeStageIndex].name,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: stageColor,
          ),
        ),
      ],
    ),
  );
}

Widget _buildSmallChart(List<PieChartModel> stages, double size) {
  return SizedBox(
    width: size,
    height: size,
    child: CustomPaint(
      size: Size(size, size),
      painter: CircularPieChartPainter(
        stages: stages,
        animationValue: 1.0,
        showText: false,
      ),
    ),
  );
}
