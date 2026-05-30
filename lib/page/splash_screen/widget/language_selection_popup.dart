import 'package:eventjar/global/store/language_store.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageSelectionPopup extends StatelessWidget {
  final VoidCallback onLanguageSelected;

  const LanguageSelectionPopup({super.key, required this.onLanguageSelected});

  @override
  Widget build(BuildContext context) {
    final languageStore = LanguageStore.to;
    final selected = 'en'.obs;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 80.wp,
          margin: EdgeInsets.symmetric(horizontal: 5.wp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.wp, vertical: 3.hp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language,
                  size: 10.wp,
                  color: const Color(0xFF1C56BF),
                ),
                SizedBox(height: 1.5.hp),
                Text(
                  'Choose Your Language',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1a365d),
                  ),
                ),
                SizedBox(height: 0.5.hp),
                Text(
                  'Select your preferred language',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 2.5.hp),
                Obx(() {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 4.wp),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF1C56BF),
                        width: 1.5,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selected.value,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF1C56BF),
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1a365d),
                        ),
                        items: languageStore.languages.map((lang) {
                          return DropdownMenuItem<String>(
                            value: lang.code,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    lang.nativeName != lang.name
                                        ? '${lang.name} (${lang.nativeName})'
                                        : lang.name,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1a365d),
                                    ),
                                  ),
                                ),
                              ],
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
                SizedBox(height: 2.5.hp),
                SizedBox(
                  width: double.infinity,
                  height: 6.hp,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1C56BF), Color(0xFF167B4D)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        languageStore.setLanguage(selected.value);
                        onLanguageSelected();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
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
