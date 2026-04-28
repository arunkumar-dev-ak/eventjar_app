import 'package:eventjar/controller/add_friend/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendInvitationAddFriend extends GetView<AddFriendController> {
  const SendInvitationAddFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Text(
            "Send Invitation Via",
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),

          SizedBox(height: 1.5.hp),

          // OPTIONS ROW
          Row(
            children: [
              // PHONE
              Expanded(
                child: _sendViaCard(
                  context: context,
                  title: "Phone",
                  icon: Icons.phone,
                  value: controller.state.sendViaPhone.value,
                  onChanged: (val) => controller.state.sendViaPhone.value = val,
                ),
              ),

              SizedBox(width: 3.wp),

              // EMAIL
              Expanded(
                child: _sendViaCard(
                  context: context,
                  title: "Email",
                  icon: Icons.email_outlined,
                  value: controller.state.sendViaEmail.value,
                  onChanged: (val) => controller.state.sendViaEmail.value = val,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _sendViaCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark
        ? const Color(0xFF5B9BEF)
        : AppColors.gradientDarkStart;

    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value
                ? accent.withValues(alpha: 0.5)
                : AppColors.border(context),
            width: 1.5,
          ),
          color: value ? accent.withValues(alpha: 0.08) : Colors.transparent,
        ),
        child: Row(
          children: [
            // ICON
            Icon(
              icon,
              size: 18,
              color: value ? accent : AppColors.iconMuted(context),
            ),

            SizedBox(width: 2.wp),

            // TEXT
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: value ? accent : AppColors.textPrimary(context),
                ),
              ),
            ),

            // SWITCH
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: value,
                onChanged: (val) {
                  HapticHelper.selection();
                  onChanged(val);
                },
                activeThumbColor: Colors.white,
                activeTrackColor: accent.withValues(alpha: 0.8),
                inactiveThumbColor: isDark
                    ? Colors.grey.shade300
                    : Colors.white,
                inactiveTrackColor: isDark
                    ? Colors.grey.shade700
                    : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
