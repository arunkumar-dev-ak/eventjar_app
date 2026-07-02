import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/global/whatsapp_chat.dart';
import 'package:eventjar/model/contact/contact_ui_model.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/page/contact/radial_design/circular_pie_chart_painter.dart';
import 'package:eventjar/page/contact/radial_design/contact_card_popup.dart';
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
    final onEventJar = contact.isEventJarUser;

    final collapsedChartSize = isSmallScreen ? 50.0 : 60.0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticHelper.light();
          controller.state.expandedIndex.value = index;
        },
        splashColor: stageColor.withValues(alpha: 0.3),
        highlightColor: stageColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isExpanded) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSmallChart(
                      stages,
                      collapsedChartSize,
                      contact.linkedUser?['avatarUrl'],
                      contact.name,
                    ),
                    SizedBox(width: 3.wp),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: stageColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  capitalizeName(contact.name),
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimaryStatic,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (contact.isOverdue)
                                Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.warning_rounded,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(Icons.circle, size: 8, color: stageColor),
                              SizedBox(width: 4),
                              Text(
                                stageDefinitions[activeStageIndex].name.tr,
                                style: TextStyle(
                                  fontSize: 6.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: stageColor,
                                ),
                              ),
                              SizedBox(width: 8),
                              if (onEventJar) ...[
                                Icon(
                                  Icons.check_circle,
                                  size: 12,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'on_myeventjar'.tr,
                                  style: TextStyle(
                                    fontSize: 6.5.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 4),
                          _buildInfoRow(
                            Icons.email_outlined,
                            AppColors.textSecondary(context),
                            contact.email,
                          ),
                          if (contact.phone != null)
                            _buildInfoRow(
                              Icons.phone_outlined,
                              AppColors.textSecondary(context),
                              contact.phone ?? 'no_phone'.tr,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 2.wp),
                    ContactCardPopupMenu(contact: contact),
                  ],
                ),

                SizedBox(height: 10),

                Divider(height: 1, color: AppColors.divider(context)),

                SizedBox(height: 6),

                _buildQuickActions(context, contact, controller, onEventJar),
              ],

              // Expanded Header (Current → Next Stage)
              if (isExpanded) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                capitalizeName(contact.name),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              SizedBox(height: 3),
                              _buildInfoRow(
                                Icons.email_outlined,
                                AppColors.textSecondary(context),
                                contact.email,
                              ),
                              if (contact.phone != null) ...[
                                SizedBox(height: 0.5.hp),
                                _buildInfoRowCompact(
                                  Icons.phone_rounded,
                                  AppColors.textSecondary(context),
                                  contact.phone!,
                                ),
                              ],
                              SizedBox(height: 0.5.hp),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    EventJarInviteBadge(
                                      onEventJar: onEventJar,
                                      phone: contact.phone,
                                      name: contact.name,
                                      parentContext: context,
                                    ),
                                    if (onEventJar) ...[
                                      SizedBox(width: 2.wp),
                                      _buildViewProfileBadge(
                                        context,
                                        controller,
                                        contact,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              SizedBox(height: 0.3.hp),
                            ],
                          ),
                        ),
                        SizedBox(width: 2.wp),
                        ContactCardPopupMenu(contact: contact),
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
                                child: _buildTagChip(tag),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                    SizedBox(height: 1.hp),
                  ],
                ),
              ],

              // --- Tags for collapsed ---
              if (!isExpanded && contact.tags.isNotEmpty) ...[
                SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: contact.tags.map((tag) {
                      return Padding(
                        padding: EdgeInsets.only(right: 1.wp),
                        child: _buildTagChip(tag),
                      );
                    }).toList(),
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

/*----- Quick action buttons -----*/
Widget _buildQuickActions(
  BuildContext context,
  MobileContact contact,
  ContactController controller,
  bool onEventJar,
) {
  const actionColor = Color(0xFF42A5F5);
  final invitedUserName = UserStore.to.profile['name'] ?? "Someone";
  final actions = <_QuickAction>[
    _QuickAction(
      iconWidget: Icon(Icons.send_rounded, size: 20, color: actionColor),
      color: actionColor,
      label: 'send'.tr,
      onTap: () => controller.navigateToNfc(),
    ),
    _QuickAction(
      iconWidget: Icon(Icons.download_rounded, size: 20, color: actionColor),
      color: actionColor,
      label: 'received'.tr,
      onTap: () => controller.navigateToReceive(),
    ),
    if (onEventJar)
      _QuickAction(
        iconWidget: Icon(Icons.person_rounded, size: 20, color: actionColor),
        color: actionColor,
        label: 'view_profile'.tr,
        onTap: () {
          final username = contact.username ?? contact.linkedUser?['username'];
          if (username != null && username.toString().isNotEmpty) {
            controller.navigateToBioPage(username.toString());
          }
        },
      ),
    if (!onEventJar)
      _QuickAction(
        iconWidget: Icon(
          Icons.person_add_rounded,
          size: 20,
          color: actionColor,
        ),
        color: actionColor,
        label: 'invite_to_myeventjar'.tr,
        onTap: () => inviteToEventJarOnWhatsApp(
          phone: contact.phone,
          name: contact.name,
          invitedUserName: invitedUserName,
          context: context,
        ),
      ),
    _QuickAction(
      iconWidget: Icon(Icons.share_rounded, size: 20, color: actionColor),
      color: actionColor,
      label: 'share_profile'.tr,
      onTap: () {
        final currentUserName = UserStore.to.profile['username'];
        if (contact.phone != null) {
          WhatsAppHelper.sendWhatsAppMessage(
            phoneNumber: contact.phone!,
            context: context,
            message: 'https://myeventjar.com/members/$currentUserName',
          );
        }
      },
    ),
  ];

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: actions
        .map((action) => Expanded(child: _buildActionButton(context, action)))
        .toList(),
  );
}

Widget _buildActionButton(BuildContext context, _QuickAction action) {
  return GestureDetector(
    onTap: () {
      HapticHelper.light();
      action.onTap();
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: action.color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(child: action.iconWidget),
        ),
        SizedBox(height: 4),
        Text(
          action.label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 5.5.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondaryStatic,
          ),
        ),
      ],
    ),
  );
}

class _QuickAction {
  final Widget iconWidget;
  final Color color;
  final String label;
  final VoidCallback onTap;

  _QuickAction({
    required this.iconWidget,
    required this.color,
    required this.label,
    required this.onTap,
  });
}

/*----- Tag chip -----*/
Widget _buildTagChip(String tag) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 0.5.hp),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.blue.shade200, width: 1),
    ),
    child: Text(
      tag,
      style: TextStyle(
        fontSize: 6.5.sp,
        color: Colors.blue.shade700,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

/*----- Collapsed helper -----*/
Widget _buildInfoRow(IconData icon, Color iconColor, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 2),
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

Widget _buildViewProfileBadge(
  BuildContext context,
  ContactController controller,
  MobileContact contact,
) {
  return GestureDetector(
    onTap: () {
      final username = contact.username ?? contact.linkedUser?['username'];
      if (username != null && username.toString().isNotEmpty) {
        controller.navigateToBioPage(username.toString());
      }
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.wp, vertical: 0.6.hp),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_outline, size: 12, color: Colors.purple),
          SizedBox(width: 1.wp),
          Text(
            'view_profile'.tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 6.5.sp,
              fontWeight: FontWeight.w600,
              color: Colors.purple,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSmallChart(
  List<PieChartModel> stages,
  double size,
  String? avatarUrl,
  String name,
) {
  final initials = name
      .split(' ')
      .map((n) => n.isNotEmpty ? n[0] : '')
      .take(2)
      .join()
      .toUpperCase();
  final avatarSize = size * 0.6;

  return SizedBox(
    width: size,
    height: size,
    child: Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(size, size),
          painter: CircularPieChartPainter(
            stages: stages,
            animationValue: 1.0,
            showText: false,
            isDarkMode: Get.isDarkMode,
          ),
        ),
        CircleAvatar(
          radius: avatarSize / 2,
          backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
              ? NetworkImage(getFileUrl(avatarUrl))
              : null,
          backgroundColor: avatarUrl != null && avatarUrl.isNotEmpty
              ? Colors.transparent
              : AppColors.gradientDarkStart,
          child: avatarUrl == null || avatarUrl.isEmpty
              ? Text(
                  initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: avatarSize * 0.35,
                  ),
                )
              : null,
        ),
      ],
    ),
  );
}
