import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/page/contact/radial_design/radial_design_func.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

//Delete Popup
class ContactCardDeletePopup extends StatelessWidget {
  final String contactName;
  final VoidCallback onDelete;

  const ContactCardDeletePopup({
    super.key,
    required this.contactName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(24),
        constraints: BoxConstraints(maxWidth: 90.wp),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_forever_rounded,
                size: 36,
                color: Colors.red.shade500,
              ),
            ),
            SizedBox(height: 1.hp),

            // Title
            Text(
              'delete_contact'.tr,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.hp),

            // Subtitle
            Text(
              '${"delete_confirm_prompt".tr} "$contactName"?',
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.textSecondary(context),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.hp),

            // Warning message
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade700,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'permanent_action_warning'.tr,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.hp),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.chipBg(context),
                      foregroundColor: AppColors.textSecondary(context),
                      padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'cancel'.tr,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.wp),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade500,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      onDelete(); // Execute delete
                    },
                    child: Text(
                      'delete'.tr,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//List Popuop
class ContactCardPopupMenu extends StatelessWidget {
  final MobileContact contact;
  final ContactController controller = Get.find();

  ContactCardPopupMenu({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final userName = contact.username;
    return PopupMenuButton<ContactCardAction>(
      icon: Container(
        padding: const EdgeInsets.all(8),
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
          value: ContactCardAction.call,
          child: Row(
            children: [
              const Icon(Icons.phone, color: Colors.green, size: 18),
              const SizedBox(width: 8),
              Text(
                'call'.tr,
                style: TextStyle(color: AppColors.textPrimary(context)),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: ContactCardAction.mail,
          child: Row(
            children: [
              const Icon(Icons.email, color: Colors.blue, size: 18),
              const SizedBox(width: 8),
              Text(
                'send_mail'.tr,
                style: TextStyle(color: AppColors.textPrimary(context)),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: ContactCardAction.whatsapp,
          child: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.whatsapp,
                color: Color(0xFF25D366),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'WhatsApp',
                style: TextStyle(color: AppColors.textPrimary(context)),
              ),
            ],
          ),
        ),
        if (userName != null && userName.isNotEmpty)
          PopupMenuItem(
            value: ContactCardAction.viewProfile,
            child: Row(
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.teal,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'view_profile'.tr,
                  style: TextStyle(color: AppColors.textPrimary(context)),
                ),
              ],
            ),
          ),
        PopupMenuItem(
          value: ContactCardAction.shareProfile,
          child: Row(
            children: [
              const Icon(Icons.share_outlined, color: Colors.purple, size: 18),
              const SizedBox(width: 8),
              Text(
                'share_profile'.tr,
                style: TextStyle(color: AppColors.textPrimary(context)),
              ),
            ],
          ),
        ),
        if (!contact.isEventJarUser)
          PopupMenuItem(
            value: ContactCardAction.inviteToEventJar,
            child: Row(
              children: [
                const Icon(Icons.person_add, color: Colors.blue, size: 18),
                const SizedBox(width: 8),
                Text(
                  'invite_to_myeventjar'.tr,
                  style: TextStyle(color: AppColors.textPrimary(context)),
                ),
              ],
            ),
          ),
        PopupMenuItem(
          value: ContactCardAction.addToPhone,
          child: Row(
            children: [
              const Icon(Icons.contacts, color: Colors.purple, size: 18),
              const SizedBox(width: 8),
              Text(
                'add_to_phone'.tr,
                style: TextStyle(color: AppColors.textPrimary(context)),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: ContactCardAction.edit,
          child: Row(
            children: [
              const Icon(Icons.edit, color: Colors.blue, size: 18),
              const SizedBox(width: 8),
              Text(
                'edit_contact'.tr,
                style: TextStyle(color: AppColors.textPrimary(context)),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: ContactCardAction.delete,
          child: Row(
            children: [
              const Icon(Icons.delete_outline, color: Colors.red, size: 18),
              const SizedBox(width: 8),
              Text(
                'delete_contact'.tr,
                style: TextStyle(color: AppColors.textPrimary(context)),
              ),
            ],
          ),
        ),
      ],
      onSelected: (action) {
        handleContactCardAction(context, action, contact, controller);
      },
    );
  }
}
