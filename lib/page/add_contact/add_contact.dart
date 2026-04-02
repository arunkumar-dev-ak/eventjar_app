import 'package:eventjar/controller/add_contact/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/add_contact/add_contact_form_element.dart';
import 'package:eventjar/page/add_contact/add_contact_header_widgets.dart';
import 'package:eventjar/page/add_contact/add_contact_multi_tag.dart';
import 'package:eventjar/page/add_contact/add_contact_stage_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/country_picker_dialog.dart';
import 'package:get/get.dart';

import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';

class AddContactPage extends GetView<AddContactController> {
  const AddContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.appBarTitle,
          style: TextStyle(color: AppColors.textPrimary(context)),
        ),
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary(context)),
        elevation: 4,
        backgroundColor: AppColors.cardBg(context),
        shadowColor: Colors.black.withValues(alpha: 0.5),
      ),
      body: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.wp),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                AddContactImagePreview(),
                AddContactImageToggle(),
                SizedBox(height: 2.hp),

                // Name
                ContactFormElement(
                  controller: controller.nameController,
                  label: 'Name *',
                  validator: controller.validateName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 2.hp),

                // Email
                ContactFormElement(
                  controller: controller.emailController,
                  label: 'Email *',
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 2.hp),

                // Phone 1
                IntlPhoneField(
                  decoration: _phoneDecoration('Phone Number *'),
                  pickerDialogStyle: _pickerStyle(),
                  initialCountryCode:
                      controller.state.selectedCountry.value.code,
                  onChanged: (_) {},
                  onCountryChanged: (country) {
                    controller.state.selectedCountry.value = country;
                  },
                  controller: controller.phoneController,
                  validator: (value) {
                    if (value == null || !value.isValidNumber()) {
                      return 'Invalid phone number';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 2.hp),

                // Stage dropdown
                ContactStageDropdown(),
                SizedBox(height: 2.hp),

                // Tags
                AddMultiSelectTagsInput(),
                SizedBox(height: 2.hp),

                // Notes
                ContactFormElement(
                  controller: controller.notesController,
                  label: 'Notes',
                  maxLines: 4,
                  minLines: 3,
                ),
                SizedBox(height: 2.hp),

                // ── Extract from Card button — visiting card update only ──
                Obx(() {
                  // Read observables first so GetX registers them as dependencies
                  final isFromCard = controller.state.isFromCardScan.value;
                  final isExtracting =
                      controller.state.isExtractingFromCard.value;
                  if (!controller.checkIsForUpdate() || !isFromCard) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: isExtracting
                            ? OutlinedButton.icon(
                                onPressed: null,
                                icon: const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                label: Text(
                                  'Extracting...',
                                  style: TextStyle(fontSize: 9.sp),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 1.2.hp,
                                  ),
                                  side: BorderSide(color: Colors.blue.shade200),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              )
                            : OutlinedButton.icon(
                                onPressed:
                                    controller.extractAdditionalInfoFromCard,
                                icon: Icon(
                                  Icons.document_scanner_outlined,
                                  size: 16,
                                  color: Colors.blue.shade700,
                                ),
                                label: Text(
                                  'Extract Additional Info from Card',
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 1.2.hp,
                                  ),
                                  side: BorderSide(color: Colors.blue.shade400),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 2.hp),
                    ],
                  );
                }),

                // ── Additional Info section (always visible) ──
                _buildAdditionalInfoSection(context),
                SizedBox(height: 3.hp),

                // Submit row
                SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => OutlinedButton(
                            onPressed: controller.state.isLoading.value
                                ? null
                                : controller.clearForm,
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.wp,
                                vertical: 1.8.hp,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.blue.shade300
                                    : Colors.blue.shade700,
                                width: 2,
                              ),
                              backgroundColor: AppColors.cardBg(context),
                              foregroundColor: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.blue.shade300
                                  : Colors.blue.shade700,
                            ),
                            child: Text(
                              controller.state.clearButtonTitle.value,
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.wp),
                      Expanded(
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: () {
                              if (controller.state.isLoading.value) return;
                              if (controller.formKey.currentState?.validate() ??
                                  false) {
                                Get.focusScope?.unfocus();
                                controller.submitForm(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.wp,
                                vertical: 1.8.hp,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              elevation: 5,
                            ),
                            child: controller.state.isLoading.value
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    controller.appBarTitle,
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoSection(BuildContext context) {
    return Obx(() {
      final isExpanded = controller.state.isAdditionalInfoExpanded.value;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider(context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Tappable Header ──
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => controller.state.isAdditionalInfoExpanded.toggle(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Additional Info',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                    // Select All checkbox — only for visiting card contacts
                    if (isExpanded && controller.state.isFromCardScan.value)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() {
                            final anyChecked = controller
                                .state
                                .additionalInfoSelection
                                .values
                                .any((v) => v);
                            final allChecked = controller
                                .state
                                .additionalInfoSelection
                                .values
                                .every((v) => v);
                            final checkboxValue = allChecked
                                ? true
                                : (anyChecked ? null : false);
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  allChecked ? 'Uncheck All' : 'Check All',
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    color: AppColors.textSecondary(context),
                                  ),
                                ),
                                Checkbox(
                                  value: checkboxValue,
                                  tristate: true,
                                  activeColor: Colors.blue.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  onChanged: (_) =>
                                      controller.toggleAllAdditionalFields(),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Collapsible content ──
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity, height: 0),
              secondChild: Column(
                children: [
                  Divider(height: 1, color: AppColors.divider(context)),

                  // ── Phone 2 ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 12, 16, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => controller.state.isFromCardScan.value
                              ? Checkbox(
                                  value:
                                      controller
                                          .state
                                          .additionalInfoSelection['phone2'] ??
                                      false,
                                  activeColor: Colors.blue.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  onChanged: (_) =>
                                      controller.toggleAdditionalField('phone2'),
                                )
                              : const SizedBox(width: 16),
                        ),
                        Expanded(
                          child: Obx(
                            () => IntlPhoneField(
                              key: ValueKey(
                                '${controller.state.selectedPhone2Country.value.code}_${controller.state.phone2FieldKey.value}',
                              ),
                              decoration: _phoneDecoration('Phone Number'),
                              pickerDialogStyle: _pickerStyle(),
                              initialCountryCode:
                                  controller.state.selectedPhone2Country.value.code,
                              onCountryChanged: (country) {
                                controller.state.selectedPhone2Country.value = country;
                              },
                              controller: controller.phone2Controller,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (phone) {
                                final value = controller.phone2Controller.text.trim();
                                if (value.isEmpty) return null;
                                if (phone != null && !phone.isValidNumber()) {
                                  return 'Enter valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Company ──
                  _buildFieldRow(
                    fieldKey: 'company',
                    child: ContactFormElement(
                      controller: controller.companyController,
                      label: 'Company',
                      keyboardType: TextInputType.text,
                      onTap: () => _autoCheck('company'),
                    ),
                  ),

                  // ── Website ──
                  _buildFieldRow(
                    fieldKey: 'website',
                    child: ContactFormElement(
                      controller: controller.websiteController,
                      label: 'Website',
                      keyboardType: TextInputType.url,
                      onTap: () => _autoCheck('website'),
                    ),
                  ),

                  // ── Address ──
                  _buildFieldRow(
                    fieldKey: 'address',
                    child: ContactFormElement(
                      controller: controller.addressController,
                      label: 'Address',
                      maxLines: 2,
                      minLines: 2,
                      onTap: () => _autoCheck('address'),
                    ),
                  ),

                  SizedBox(height: 8),
                ],
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      );
    });
  }

  void _autoCheck(String fieldKey) {
    if (!controller.state.isFromCardScan.value) return;
    if (!(controller.state.additionalInfoSelection[fieldKey] ?? false)) {
      controller.toggleAdditionalField(fieldKey);
    }
  }

  Widget _buildFieldRow({required String fieldKey, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(
            () => controller.state.isFromCardScan.value
                ? Checkbox(
                    value:
                        controller.state.additionalInfoSelection[fieldKey] ??
                        false,
                    activeColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (_) =>
                        controller.toggleAdditionalField(fieldKey),
                  )
                : const SizedBox(width: 16),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  InputDecoration _phoneDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontSize: 10.sp),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: AppColors.borderStatic, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: AppColors.isDark ? Colors.blue.shade300 : Colors.blue.shade700, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
      ),
      errorStyle: const TextStyle(height: 0),
    );
  }

  PickerDialogStyle _pickerStyle() {
    return PickerDialogStyle(
      countryNameStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 10.sp),
      countryCodeStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
    );
  }
}
