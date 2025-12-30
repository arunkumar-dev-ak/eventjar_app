import 'package:country_code_picker/country_code_picker.dart';
import 'package:eventjar/controller/add_contact/controller.dart';
import 'package:eventjar/global/app_colors.dart';
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
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildModernAppBar(),
      body: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 2.hp),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                _buildHeaderCard(),

                SizedBox(height: 2.hp),

                // Contact Details Section
                _buildSectionCard(
                  title: 'Contact Details',
                  icon: Icons.person_outline_rounded,
                  children: [
                    // Name
                    ContactFormElement(
                      controller: controller.nameController,
                      label: 'Full Name',
                      prefixIcon: Icons.person_rounded,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Name is required'
                          : null,
                    ),
                    SizedBox(height: 2.hp),

                    // Email
                    ContactFormElement(
                      controller: controller.emailController,
                      label: 'Email Address',
                      prefixIcon: Icons.email_rounded,
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
                    _buildPhoneField(),
                  ],
                ),

                SizedBox(height: 2.hp),

                // Classification Section
                _buildSectionCard(
                  title: 'Classification',
                  icon: Icons.category_outlined,
                  children: [
                    // Stage dropdown
                    ContactStageDropdown(),
                    SizedBox(height: 2.hp),

                    // Tags
                    MultiSelectTagsInput(),
                  ],
                ),

                SizedBox(height: 2.hp),

                // Notes Section
                _buildSectionCard(
                  title: 'Notes',
                  icon: Icons.note_alt_outlined,
                  children: [
                    ContactFormElement(
                      controller: controller.notesController,
                      label: 'Add notes about this contact...',
                      prefixIcon: Icons.edit_note_rounded,
                      maxLines: 4,
                      minLines: 3,
                    ),
                  ],
                ),

                SizedBox(height: 3.hp),

                // Action Buttons
                _buildActionButtons(context),

                SizedBox(height: 2.hp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: AppColors.appBarGradient,
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(2.wp),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: Colors.white,
          ),
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        controller.appBarTitle,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gradientDarkStart.withValues(alpha: 0.1),
            AppColors.gradientDarkEnd.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.gradientDarkStart.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.wp),
            decoration: BoxDecoration(
              color: AppColors.gradientDarkStart.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.person_add_alt_1_rounded,
              size: 24,
              color: AppColors.gradientDarkStart,
            ),
          ),
          SizedBox(width: 3.wp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.appBarTitle,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 0.3.hp),
                Text(
                  'Fill in the details to add a new contact to your network',
                  style: TextStyle(
                    fontSize: 7.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: EdgeInsets.fromLTRB(4.wp, 3.wp, 4.wp, 2.wp),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.wp),
                  decoration: BoxDecoration(
                    color: AppColors.gradientDarkStart.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: AppColors.gradientDarkStart,
                  ),
                ),
                SizedBox(width: 2.wp),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          Padding(
            padding: EdgeInsets.all(4.wp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country Code Picker
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
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
            padding: EdgeInsets.zero,
            textStyle: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 2.wp),
        // Phone Number Field
        Expanded(
          child: ContactFormElement(
            controller: controller.phoneController,
            label: 'Phone Number',
            prefixIcon: Icons.phone_rounded,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ],
            validator: (val) =>
                val == null || val.trim().isEmpty ? 'Phone is required' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Clear Button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: controller.clearForm,
            icon: Icon(Icons.clear_rounded, size: 18),
            label: Text(
              'Clear',
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.8.hp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: Colors.grey.shade400,
                width: 1.5,
              ),
              foregroundColor: Colors.grey.shade700,
            ),
          ),
        ),
        SizedBox(width: 3.wp),
        // Submit Button
        Expanded(
          flex: 2,
          child: Obx(() {
            final isLoading = controller.state.isLoading.value;
            return ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      Get.focusScope?.unfocus();
                      controller.submitForm(context);
                    },
              icon: isLoading
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(Icons.check_rounded, size: 18),
              label: Text(
                isLoading ? 'Saving...' : controller.appBarTitle,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.8.hp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                backgroundColor: AppColors.gradientDarkStart,
                foregroundColor: Colors.white,
              ),
            );
          }),
        ),
      ],
    );
  }
}
