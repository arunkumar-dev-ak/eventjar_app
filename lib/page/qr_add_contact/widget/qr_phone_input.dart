import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class QrPhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final RxString countryCode;
  final String? Function(String?)? validator;

  const QrPhoneInput({
    super.key,
    required this.controller,
    required this.countryCode,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Define a consistent border color
    final borderColor = colorScheme.outline.withAlpha(
      50,
    ); // soft grey similar to country picker

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country picker
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withAlpha(30),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: CountryCodePicker(
            onChanged: (code) {
              countryCode.value = code.dialCode ?? '+91';
            },
            initialSelection: 'IN',
            favorite: const ['+91', 'IN'],
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            textStyle: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            dialogBackgroundColor: colorScheme.surface,
          ),
        ),

        const SizedBox(width: 8),

        // Phone number field
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ],
            validator: validator,
            decoration: InputDecoration(
              hintText: 'Enter phone number',
              prefixIcon: Icon(Icons.phone_rounded, color: colorScheme.primary),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withAlpha(30),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
