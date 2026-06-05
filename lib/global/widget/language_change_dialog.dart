import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/store/language_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLanguageChangeDialog(BuildContext context) {
  final languageStore = LanguageStore.to;
  final selected = languageStore.selectedLanguageCode.obs;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.cardBg(context),
        title: Row(
          children: [
            Icon(
              Icons.language,
              color: Theme.of(context).colorScheme.primary,
              size: 7.wp,
            ),
            SizedBox(width: 2.wp),
            Text(
              'Change Language',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(context),
              ),
            ),
          ],
        ),
        content: Obx(() {
          return Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 4.wp),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardElevated : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selected.value,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                dropdownColor: AppColors.cardBg(context),
                borderRadius: BorderRadius.circular(12),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary(context),
                ),
                items: languageStore.languages.map((lang) {
                  return DropdownMenuItem<String>(
                    value: lang.code,
                    child: Text(
                      lang.nativeName != lang.name
                          ? '${lang.name} (${lang.nativeName})'
                          : lang.name,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) selected.value = value;
                },
              ),
            ),
          );
        }),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary(context)),
            ),
          ),
          Obx(() {
            final changed = selected.value != languageStore.selectedLanguageCode;
            return ElevatedButton(
              onPressed: changed
                  ? () {
                      languageStore.setLanguage(selected.value);
                      Navigator.pop(dialogContext);
                      Get.snackbar(
                        'language_updated'.tr,
                        '${'language_changed_to'.tr} ${languageStore.selectedLanguageName}',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                        duration: const Duration(seconds: 2),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                disabledBackgroundColor: AppColors.chipBg(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: changed ? Colors.white : AppColors.textHint(context),
                ),
              ),
            );
          }),
        ],
      );
    },
  );
}
