import 'package:eventjar/controller/more/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/store/theme_store.dart';
import 'package:eventjar/global/widget/language_change_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eventjar/global/whatsapp_chat.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MorePage extends GetView<MoreController> {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Container(
        width: 100.wp,
        color: isDark ? AppColors.darkBackground : Colors.white,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.wp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.hp),

                // Header text
                Padding(
                  padding: EdgeInsets.only(left: 1.wp),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'explore'.tr,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary(context),
                                letterSpacing: 0.5,
                              ),
                            ),
                            ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  AppColors.gradientDarkStart,
                                  AppColors.gradientDarkEnd,
                                ],
                              ).createShader(bounds),
                              child: Text(
                                "MyEventJar",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          _buildWhatsAppButton(context, isDark),
                          SizedBox(width: 1.wp),
                          _buildLanguageButton(context, isDark),
                          SizedBox(width: 1.wp),
                          _buildThemeToggle(context, isDark),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.hp),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Your Contact Section
                        _buildSectionTitle(context, 'contact'.tr),
                        SizedBox(height: 1.5.hp),
                        _buildIconGrid(context, isDark, [
                          _GridItem(
                            icon: Icons.person_add_alt_1_rounded,
                            label: 'add_contacts'.tr,
                            onTap: controller.navigateToAddContact,
                          ),
                          _GridItem(
                            icon: Icons.nfc_rounded,
                            label: 'tap_nfc_card'.tr,
                            onTap: controller.navigateToNfcRead,
                          ),
                          _GridItem(
                            icon: Icons.qr_code_scanner_rounded,
                            label: 'qr_scanner'.tr,
                            onTap: controller.navigateToQrDashboard,
                          ),
                          _GridItem(
                            icon: Icons.document_scanner,
                            label: 'scan_business_card'.tr,
                            onTap: controller.navigateToScanCard,
                          ),
                        ]),

                        SizedBox(height: 3.hp),

                        // Budget Section
                        _buildSectionTitle(context, 'budget'.tr),
                        SizedBox(height: 1.5.hp),
                        _buildIconGrid(context, isDark, [
                          _GridItem(
                            icon: Icons.flight_outlined,
                            label: 'trips'.tr,
                            onTap: controller.navigateToBudgetTrack,
                          ),
                          _GridItem(
                            icon: Icons.people_outline,
                            label: 'friends'.tr,
                            onTap: controller.navigateToFriendList,
                          ),
                          // _GridItem(
                          //   icon: Icons.receipt_long_outlined,
                          //   label: 'transactions'.tr,
                          //   onTap: controller.navigateToTransaction,
                          // ),
                        ]),

                        SizedBox(height: 3.hp),

                        SizedBox(height: 3.hp),

                        // Your Network Section
                        _buildSectionTitle(context, 'your_network_caps'.tr),
                        SizedBox(height: 1.5.hp),
                        _buildIconGrid(context, isDark, [
                          _GridItem(
                            icon: Icons.contacts_outlined,
                            label: 'total_contacts'.tr,
                            onTap: controller.navigateToTotalContacts,
                          ),
                          _GridItem(
                            icon: Icons.fiber_new_outlined,
                            label: 'new_contacts'.tr,
                            onTap: controller.navigateToNewContacts,
                          ),
                          _GridItem(
                            icon: Icons.schedule,
                            label: 'twenty_four_h_followup'.tr,
                            onTap: controller.navigateTo24hFollowup,
                          ),
                          _GridItem(
                            icon: Icons.date_range_outlined,
                            label: 'seven_d_followup'.tr,
                            onTap: controller.navigateTo7dFollowup,
                          ),
                          _GridItem(
                            icon: Icons.calendar_month_outlined,
                            label: 'thirty_d_followup'.tr,
                            onTap: controller.navigateTo30dFollowup,
                          ),
                          _GridItem(
                            icon: Icons.verified_outlined,
                            label: 'qualified_contacts'.tr,
                            onTap: controller.navigateToQualifiedContacts,
                          ),
                        ]),

                        SizedBox(height: 3.hp),

                        // Connections Section
                        _buildSectionTitle(context, 'connections_caps'.tr),
                        SizedBox(height: 1.5.hp),
                        _buildIconGrid(context, isDark, [
                          _GridItem(
                            icon: Icons.send_outlined,
                            label: 'send'.tr,
                            onTap: controller.navigateToConnectionSend,
                          ),
                          _GridItem(
                            icon: Icons.call_received_outlined,
                            label: 'received'.tr,
                            onTap: controller.navigateToConnectionReceived,
                          ),
                        ]),

                        SizedBox(height: 3.hp),

                        // Meeting Section
                        _buildSectionTitle(context, 'meeting_caps'.tr),
                        SizedBox(height: 1.5.hp),
                        _buildIconGrid(context, isDark, [
                          _GridItem(
                            icon: Icons.list_alt_outlined,
                            label: 'all'.tr,
                            onTap: controller.navigateToAllMeetings,
                          ),
                          _GridItem(
                            icon: Icons.event_outlined,
                            label: 'scheduled'.tr,
                            onTap: controller.navigateToScheduledMeetings,
                          ),
                          _GridItem(
                            icon: Icons.check_circle_outline,
                            label: 'confirmed'.tr,
                            onTap: controller.navigateToConfirmedMeetings,
                          ),
                          _GridItem(
                            icon: Icons.cancel_outlined,
                            label: 'declined'.tr,
                            onTap: controller.navigateToDeclinedMeetings,
                          ),
                          _GridItem(
                            icon: Icons.block_outlined,
                            label: 'cancelled'.tr,
                            onTap: controller.navigateToCancelledMeetings,
                          ),
                          _GridItem(
                            icon: Icons.task_alt_outlined,
                            label: 'completed'.tr,
                            onTap: controller.navigateToCompletedMeetings,
                          ),
                          _GridItem(
                            icon: Icons.person_off_outlined,
                            label: 'no_show'.tr,
                            onTap: controller.navigateToNoShowMeetings,
                          ),
                        ]),

                        SizedBox(height: 3.hp),

                        // Automation Section
                        _buildSectionTitle(context, 'automation'.tr),
                        SizedBox(height: 1.5.hp),
                        _buildIconGrid(context, isDark, [
                          _GridItem(
                            icon: Icons.email_outlined,
                            label: 'email'.tr,
                            onTap: controller.navigateToEmailAutomation,
                          ),
                          _GridItem(
                            icon: FontAwesomeIcons.whatsapp,
                            label: 'whatsapp'.tr,
                            isFontAwesome: true,
                            onTap: controller.navigateToWhatsAppAutomation,
                          ),
                          _GridItem(
                            icon: Icons.calendar_month_outlined,
                            label: 'google_calendar'.tr,
                            onTap:
                                controller.navigateToGoogleCalendarAutomation,
                          ),
                        ]),

                        SizedBox(height: 3.hp),

                        // Others Section
                        _buildSectionTitle(context, 'others'.tr),
                        SizedBox(height: 1.5.hp),
                        _buildIconGrid(context, isDark, [
                          _GridItem(
                            icon: Icons.event_outlined,
                            label: 'events'.tr,
                            onTap: controller.navigateToCategoryEvent,
                          ),
                          _GridItem(
                            icon: Icons.shield_outlined,
                            label: 'two_fa'.tr,
                            onTap: controller.navigateToSet2FA,
                          ),
                          _GridItem(
                            icon: Icons.lock_reset_outlined,
                            label: 'change_password'.tr,
                            onTap: controller.navigateToChangePassword,
                          ),
                        ]),

                        SizedBox(height: 4.hp),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 1.wp),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 8.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary(context),
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildIconGrid(
    BuildContext context,
    bool isDark,
    List<_GridItem> items,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];
        return _buildGridTile(context, isDark, item);
      },
    );
  }

  Widget _buildGridTile(BuildContext context, bool isDark, _GridItem item) {
    final iconColor = isDark
        ? const Color(0xFF5B9BEF)
        : AppColors.gradientDarkStart;
    final borderColor = isDark
        ? const Color(0xFF2A4A6A)
        : const Color(0xFFB6D9FF);
    final bgColor = isDark ? const Color(0xFF1A2A3A) : const Color(0xFFF5FAFF);

    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
              border: Border.all(color: borderColor, width: 1.5),
            ),
            alignment: Alignment.center,
            child: item.isFontAwesome
                ? Center(child: FaIcon(item.icon, size: 22, color: iconColor))
                : Icon(item.icon, size: 24, color: iconColor),
          ),
          SizedBox(height: 0.8.hp),
          Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 7.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsAppButton(BuildContext context, bool isDark) {
    return IconButton(
      icon: FaIcon(
        FontAwesomeIcons.whatsapp,
        color: const Color(0xFF25D366),
      ),
      tooltip: 'Support',
      onPressed: () => WhatsAppHelper.openSupport(context: context),
    );
  }

  Widget _buildLanguageButton(BuildContext context, bool isDark) {
    final iconColor = isDark
        ? const Color(0xFF5B9BEF)
        : AppColors.gradientDarkStart;
    return IconButton(
      icon: Icon(Icons.language, color: iconColor),
      tooltip: 'language'.tr,
      onPressed: () => showLanguageChangeDialog(context),
    );
  }

  Widget _buildThemeToggle(BuildContext context, bool isDark) {
    final iconColor = isDark
        ? const Color(0xFF5B9BEF)
        : AppColors.gradientDarkStart;
    return Obx(() {
      final mode = ThemeStore.to.themeMode;
      final IconData icon = switch (mode) {
        ThemeMode.light => Icons.light_mode_rounded,
        ThemeMode.dark => Icons.dark_mode_rounded,
        ThemeMode.system => Icons.phone_android_rounded,
      };
      return PopupMenuButton<ThemeMode>(
        icon: Icon(icon, color: iconColor),
        tooltip: 'theme'.tr,
        onSelected: (selected) => ThemeStore.to.setThemeMode(selected),
        itemBuilder: (_) => [
          _buildThemeMenuItem(
            ThemeMode.light,
            Icons.light_mode_rounded,
            'light'.tr,
            mode,
          ),
          _buildThemeMenuItem(
            ThemeMode.dark,
            Icons.dark_mode_rounded,
            'dark'.tr,
            mode,
          ),
          _buildThemeMenuItem(
            ThemeMode.system,
            Icons.phone_android_rounded,
            'system_default'.tr,
            mode,
          ),
        ],
      );
    });
  }

  PopupMenuItem<ThemeMode> _buildThemeMenuItem(
    ThemeMode mode,
    IconData icon,
    String label,
    ThemeMode currentMode,
  ) {
    final isSelected = mode == currentMode;
    return PopupMenuItem<ThemeMode>(
      value: mode,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? AppColors.gradientDarkStart : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected ? AppColors.gradientDarkStart : null,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            Icon(Icons.check, size: 18, color: AppColors.gradientDarkStart),
          ],
        ],
      ),
    );
  }
}

class _GridItem {
  final dynamic icon;
  final String label;
  final VoidCallback? onTap;
  final bool isFontAwesome;

  const _GridItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.isFontAwesome = false,
  });
}
