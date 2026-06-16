import 'package:eventjar/controller/more/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/more/widget/more_grid.dart';
import 'package:eventjar/page/more/widget/more_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                MoreHeader(isDark: isDark),
                SizedBox(height: 3.hp),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MoreSectionTitle(title: 'contact'.tr),
                        SizedBox(height: 1.5.hp),
                        MoreIconGrid(
                          isDark: isDark,
                          items: [
                            MoreGridItem(
                              icon: Icons.person_add_alt_1_rounded,
                              label: 'add_contacts'.tr,
                              onTap: controller.navigateToAddContact,
                            ),
                            MoreGridItem(
                              icon: Icons.nfc_rounded,
                              label: 'tap_nfc_card'.tr,
                              onTap: controller.navigateToNfcRead,
                            ),
                            MoreGridItem(
                              icon: Icons.qr_code_scanner_rounded,
                              label: 'qr_scanner'.tr,
                              onTap: controller.navigateToQrDashboard,
                            ),
                            MoreGridItem(
                              icon: Icons.document_scanner,
                              label: 'scan_business_card'.tr,
                              onTap: controller.navigateToScanCard,
                            ),
                          ],
                        ),

                        SizedBox(height: 3.hp),

                        MoreSectionTitle(title: 'budget'.tr),
                        SizedBox(height: 1.5.hp),
                        MoreIconGrid(
                          isDark: isDark,
                          items: [
                            MoreGridItem(
                              icon: Icons.flight_outlined,
                              label: 'trips'.tr,
                              onTap: controller.navigateToBudgetTrack,
                            ),
                            MoreGridItem(
                              icon: Icons.people_outline,
                              label: 'friends'.tr,
                              onTap: controller.navigateToFriendList,
                            ),
                          ],
                        ),

                        SizedBox(height: 3.hp),
                        SizedBox(height: 3.hp),

                        MoreSectionTitle(title: 'your_network_caps'.tr),
                        SizedBox(height: 1.5.hp),
                        MoreIconGrid(
                          isDark: isDark,
                          items: [
                            MoreGridItem(
                              icon: Icons.contacts_outlined,
                              label: 'total_contacts'.tr,
                              onTap: controller.navigateToTotalContacts,
                            ),
                            MoreGridItem(
                              icon: Icons.fiber_new_outlined,
                              label: 'new_contacts'.tr,
                              onTap: controller.navigateToNewContacts,
                            ),
                            MoreGridItem(
                              icon: Icons.schedule,
                              label: 'twenty_four_h_followup'.tr,
                              onTap: controller.navigateTo24hFollowup,
                            ),
                            MoreGridItem(
                              icon: Icons.date_range_outlined,
                              label: 'seven_d_followup'.tr,
                              onTap: controller.navigateTo7dFollowup,
                            ),
                            MoreGridItem(
                              icon: Icons.calendar_month_outlined,
                              label: 'thirty_d_followup'.tr,
                              onTap: controller.navigateTo30dFollowup,
                            ),
                            MoreGridItem(
                              icon: Icons.verified_outlined,
                              label: 'qualified_contacts'.tr,
                              onTap: controller.navigateToQualifiedContacts,
                            ),
                          ],
                        ),

                        SizedBox(height: 3.hp),

                        MoreSectionTitle(title: 'connections_caps'.tr),
                        SizedBox(height: 1.5.hp),
                        MoreIconGrid(
                          isDark: isDark,
                          items: [
                            MoreGridItem(
                              icon: Icons.send_outlined,
                              label: 'send'.tr,
                              onTap: controller.navigateToConnectionSend,
                            ),
                            MoreGridItem(
                              icon: Icons.call_received_outlined,
                              label: 'received'.tr,
                              onTap: controller.navigateToConnectionReceived,
                            ),
                          ],
                        ),

                        SizedBox(height: 3.hp),

                        MoreSectionTitle(title: 'meeting_caps'.tr),
                        SizedBox(height: 1.5.hp),
                        MoreIconGrid(
                          isDark: isDark,
                          items: [
                            MoreGridItem(
                              icon: Icons.list_alt_outlined,
                              label: 'all'.tr,
                              onTap: controller.navigateToAllMeetings,
                            ),
                            MoreGridItem(
                              icon: Icons.event_outlined,
                              label: 'scheduled'.tr,
                              onTap: controller.navigateToScheduledMeetings,
                            ),
                            MoreGridItem(
                              icon: Icons.check_circle_outline,
                              label: 'confirmed'.tr,
                              onTap: controller.navigateToConfirmedMeetings,
                            ),
                            MoreGridItem(
                              icon: Icons.cancel_outlined,
                              label: 'declined'.tr,
                              onTap: controller.navigateToDeclinedMeetings,
                            ),
                            MoreGridItem(
                              icon: Icons.block_outlined,
                              label: 'cancelled'.tr,
                              onTap: controller.navigateToCancelledMeetings,
                            ),
                            MoreGridItem(
                              icon: Icons.task_alt_outlined,
                              label: 'completed'.tr,
                              onTap: controller.navigateToCompletedMeetings,
                            ),
                            MoreGridItem(
                              icon: Icons.person_off_outlined,
                              label: 'no_show'.tr,
                              onTap: controller.navigateToNoShowMeetings,
                            ),
                          ],
                        ),

                        SizedBox(height: 3.hp),

                        MoreSectionTitle(title: 'automation'.tr),
                        SizedBox(height: 1.5.hp),
                        MoreIconGrid(
                          isDark: isDark,
                          items: [
                            MoreGridItem(
                              icon: Icons.email_outlined,
                              label: 'email'.tr,
                              onTap: controller.navigateToEmailAutomation,
                            ),
                            MoreGridItem(
                              icon: FontAwesomeIcons.whatsapp,
                              label: 'whatsapp'.tr,
                              isFontAwesome: true,
                              onTap: controller.navigateToWhatsAppAutomation,
                            ),
                            MoreGridItem(
                              icon: Icons.calendar_month_outlined,
                              label: 'google_calendar'.tr,
                              onTap:
                                  controller.navigateToGoogleCalendarAutomation,
                            ),
                          ],
                        ),

                        SizedBox(height: 3.hp),

                        MoreSectionTitle(title: 'others'.tr),
                        SizedBox(height: 1.5.hp),
                        MoreIconGrid(
                          isDark: isDark,
                          items: [
                            MoreGridItem(
                              icon: Icons.event_outlined,
                              label: 'events'.tr,
                              onTap: controller.navigateToCategoryEvent,
                            ),
                            MoreGridItem(
                              icon: Icons.shield_outlined,
                              label: 'two_fa'.tr,
                              onTap: controller.navigateToSet2FA,
                            ),
                            MoreGridItem(
                              icon: Icons.lock_reset_outlined,
                              label: 'change_password'.tr,
                              onTap: controller.navigateToChangePassword,
                            ),
                          ],
                        ),

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
}
