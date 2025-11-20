import 'package:country_code_picker/country_code_picker.dart';
import 'package:eventjar/controller/add_contact/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/add_contact/add_contact_form_element.dart';
import 'package:eventjar/page/add_contact/add_contact_stage_dropdown.dart';
import 'package:eventjar/page/add_contact/add_contact_tag_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddContactPage extends GetView<AddContactController> {
  const AddContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultFontSize = 10.sp;

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
        onTap: () {
          Get.focusScope?.unfocus();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 3.hp),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                ContactFormElement(
                  controller: controller.nameController,
                  label: 'Name',
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Name is required'
                      : null,
                ),
                SizedBox(height: 2.hp),

                // Email
                ContactFormElement(
                  controller: controller.emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(val.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.hp),

                // Phone
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First container for CountryCodePicker
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: CountryCodePicker(
                        onChanged: (country) {
                          controller.state.selectedCountryCode.value =
                              country.dialCode ?? '+91';
                        },
                        initialSelection: 'IN',
                        favorite: ['+91', 'IN'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        dialogBackgroundColor: Colors.white,
                        textStyle: TextStyle(
                          color: Colors.grey[800],
                          fontSize: defaultFontSize,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Second container for Phone Number TextField
                    Expanded(
                      child: ContactFormElement(
                        controller: controller.phoneController,
                        label: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Phone number is required'
                            : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.hp),

                // Stage dropdown widget
                ContactStageDropdown(),

                SizedBox(height: 2.hp),

                // Multi-select tags widget
                MultiSelectTagsInput(),

                SizedBox(height: 2.hp),

                // Notes (multiline)
                ContactFormElement(
                  controller: controller.notesController,
                  label: 'Notes',
                  maxLines: 4,
                  minLines: 2,
                ),

                SizedBox(height: 3.hp),

                // Buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.clearForm,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.wp,
                            vertical: 1.8.hp,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // smoother corners
                          ),
                          side: BorderSide(
                            color: Colors.blue.shade700,
                            width: 2,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor:
                              Colors.blue.shade700, // text and icon color
                          elevation: 0,
                        ),
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: defaultFontSize,
                            fontWeight: FontWeight.w600, // bolder text
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.wp),
                    Expanded(
                      child: Obx(() {
                        final isLoading = controller.state.isLoading.value;
                        return ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () => controller.submitForm(context),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.wp,
                              vertical: 1.8.hp,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                            shadowColor: Colors.blue.shade700.withValues(
                              alpha: 0.5,
                            ),
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: defaultFontSize,
                                  width: defaultFontSize,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  controller.appBarTitle,
                                  style: TextStyle(
                                    fontSize: defaultFontSize,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        );
                      }),
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
