import 'package:country_code_picker/country_code_picker.dart';
import 'package:eventjar/controller/add_contact/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
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
        title: const Text('Add Contact', style: TextStyle(color: Colors.black)),
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 4,
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.5),
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
                TextFormField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(fontSize: defaultFontSize),
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
                  ),
                  style: TextStyle(fontSize: defaultFontSize),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Name is required'
                      : null,
                ),

                SizedBox(height: 2.hp),

                // Email
                TextFormField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: defaultFontSize),
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
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: defaultFontSize),
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

                // Phone with country code picker
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      CountryCodePicker(
                        onChanged: (country) {
                          controller.state.selectedCountryCode.value =
                              country.dialCode ?? '+91';
                        },
                        initialSelection: 'IN',
                        favorite: ['+91', 'IN'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        padding: EdgeInsets.zero,
                        dialogBackgroundColor: Colors.white,
                        textStyle: TextStyle(
                          color: Colors.grey[800],
                          fontSize: defaultFontSize,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: controller.phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(fontSize: defaultFontSize),
                            border: InputBorder.none,
                            errorStyle: TextStyle(height: 0),
                          ),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(fontSize: defaultFontSize),
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Phone number is required'
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.hp),

                // Stage dropdown widget
                ContactStageDropdown(),

                SizedBox(height: 2.hp),

                // Multi-select tags widget
                MultiSelectTagsInput(),

                SizedBox(height: 2.hp),

                // Notes (multiline)
                TextFormField(
                  controller: controller.notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    labelStyle: TextStyle(fontSize: defaultFontSize),
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
                    alignLabelWithHint: true,
                  ),
                  style: TextStyle(fontSize: defaultFontSize),
                  maxLines: 4,
                  minLines: 2,
                  keyboardType: TextInputType.multiline,
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
                            vertical: 1.5.hp,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Clear',
                          style: TextStyle(fontSize: defaultFontSize),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.wp),
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
                              vertical: 1.9.hp,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height:
                                      defaultFontSize, // adjust size as needed
                                  width: defaultFontSize,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Add Contact',
                                  style: TextStyle(fontSize: defaultFontSize),
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
