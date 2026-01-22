import 'package:eventjar/controller/add_contact/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/add_contact/add_contact_form_element.dart';
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
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 4,
        backgroundColor: Colors.white,
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
                // Name ✅ Auto-validation
                ContactFormElement(
                  controller: controller.nameController,
                  label: 'Name *',
                  validator: controller.validateName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 2.hp),

                // Email ✅ Auto-validation
                ContactFormElement(
                  controller: controller.emailController,
                  label: 'Email *',
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 2.hp),

                // ✅ MOBILE: IntlPhoneField with ContactFormElement styling
                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number *',
                    labelStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.blue.shade700,
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                        width: 2.0,
                      ),
                    ),
                    errorStyle: const TextStyle(height: 0),
                  ),
                  pickerDialogStyle: PickerDialogStyle(
                    countryNameStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                    ),
                    countryCodeStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
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
                SizedBox(height: 3.hp),

                // Submit
                Row(
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
                              color: Colors.blue.shade700,
                              width: 2,
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade700,
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

                    // Submit Button
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
