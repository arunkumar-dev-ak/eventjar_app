import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/contact_ui_model.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/page/contact/radial_design/circular_pie_chart_painter.dart';
import 'package:eventjar/page/contact/radial_design/invite_to_eventjar.dart';
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
    final List<String> tags = contact.tags;
    final onEventJar = contact.isEventJarUser;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                            isOverDue: contact.isOverdue,
                            isExpanded: isExpanded,
                            controller: controller,
                            nameFontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 3),
                          _buildInfoRow(
                            Icons.email_outlined,
                            AppColors.textSecondary(context),
                            contact.email,
                          ),
                          if (contact.phone != null)
                            _buildInfoRow(
                              Icons.phone_outlined,
                              AppColors.textSecondary(context),
                              contact.phone ?? 'No phone',
                            ),
                          SizedBox(height: 12),
                          // _buildStageBadge(stageColor, contact.stage.index),
                          Row(
                            children: [
                              _buildStageBadge(stageColor, contact.stage.index),
                              SizedBox(width: 2.wp),

                              Flexible(
                                child: EventJarInviteBadge(
                                  onEventJar: onEventJar,
                                  phone: contact.phone,
                                  name: contact.name,
                                  parentContext: context,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  // Expanded Header (Current → Next Stage)
                  if (isExpanded)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                                        color: AppColors.textPrimary(context),
                                      ),
                                    ),

                                    // Email
                                    _buildInfoRow(
                                      Icons.email_outlined,
                                      AppColors.textSecondary(context),
                                      contact.email,
                                    ),

                                    // Phone + Invite OR Only Invite
                                    if (contact.phone != null) ...[
                                      SizedBox(height: 0.5.hp),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildInfoRowCompact(
                                            Icons.phone_rounded,
                                            AppColors.textSecondary(context),
                                            contact.phone!,
                                          ),
                                          SizedBox(width: 3.wp),
                                          EventJarInviteBadge(
                                            onEventJar: onEventJar,
                                            phone: contact.phone,
                                            name: contact.name,
                                            parentContext: context,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 0.3.hp),
                                    ] else ...[
                                      SizedBox(height: 0.5.hp),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: EventJarInviteBadge(
                                          onEventJar: onEventJar,
                                          phone: null,
                                          name: contact.name,
                                          parentContext: context,
                                        ),
                                      ),
                                      SizedBox(height: 0.3.hp),
                                    ],
                                  ],
                                ),
                              ),
                              SizedBox(width: 2.wp),
                              PopupMenuButton<ContactCardAction>(
                                icon: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.divider(context),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.more_vert,
                                    size: 18,
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: ContactCardAction.mail,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.email,
                                          color: Colors.blue,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Send Mail',
                                          style: TextStyle(
                                            color: AppColors.textPrimary(context),
                                          ),
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
                                          style: TextStyle(
                                            color: AppColors.textPrimary(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!contact.isEventJarUser)
                                    PopupMenuItem(
                                      value: ContactCardAction.inviteToEventJar,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person_add,
                                            color: Colors.blue,
                                            size: 18,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Invite to MyEventJar',
                                            style: TextStyle(
                                              color: AppColors.textPrimary(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  PopupMenuItem(
                                    value: ContactCardAction.addToPhone,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.contacts,
                                          color: Colors.purple,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Add to Phone',
                                          style: TextStyle(
                                            color: AppColors.textPrimary(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: ContactCardAction.edit,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Edit Contact',
                                          style: TextStyle(
                                            color: AppColors.textPrimary(context),
                                          ),
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
                                          style: TextStyle(
                                            color: AppColors.textPrimary(context),
                                          ),
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

                          if (contact.tags.isNotEmpty)
                            Container(
                              margin: EdgeInsets.only(top: 1.hp),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: contact.tags.map((tag) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: 1.wp),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 3.wp,
                                          vertical: 0.5.hp,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: Colors.blue.shade200,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          tag,
                                          style: TextStyle(
                                            fontSize: 6.5.sp,
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),

                          SizedBox(height: 1.hp),
                        ],
                      ),
                    ),
                ],
              ),
              if (!isExpanded && contact.tags.isNotEmpty) ...[
                SizedBox(height: 1.hp),
                Container(
                  margin: EdgeInsets.only(top: 1.hp),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: contact.tags.map((tag) {
                        return Padding(
                          padding: EdgeInsets.only(right: 1.wp),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.wp,
                              vertical: 0.5.hp,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.blue.shade200,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 6.5.sp,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
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
              color: AppColors.textSecondaryStatic,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget _buildInfoRowCompact(IconData icon, Color iconColor, String value) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: iconColor),
      SizedBox(width: 6),
      Text(
        value,
        style: TextStyle(
          fontSize: 8.sp,
          color: AppColors.textSecondaryStatic,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

//phone call
Widget _buildNameWithCallButton({
  required String name,
  required MobileContact contact,
  required bool isExpanded,
  required ContactController controller,
  required bool isOverDue,
  FontWeight nameFontWeight = FontWeight.normal,
  double nameFontSize = 10.0,
  double callFontSize = 7.0,
}) {
  return Row(
    children: [
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isOverDue) ...[
              Container(
                margin: EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.warning_rounded,
                  size: 5.wp,
                  color: Colors.red,
                ),
              ),
              SizedBox(width: 1.wp),
            ],
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: nameFontSize.sp,
                  fontWeight: nameFontWeight,
                  color: AppColors.textPrimaryStatic,
                ),
              ),
            ),
          ],
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
    padding: EdgeInsets.symmetric(horizontal: 2.5.wp, vertical: 0.6.hp),
    decoration: BoxDecoration(
      color: stageColor.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: stageColor.withValues(alpha: 0.3)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 10, color: stageColor),
        SizedBox(width: 1.wp),
        Text(
          stageDefinitions[activeStageIndex].name,
          style: TextStyle(
            fontSize: 6.5.sp,
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
