import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

Widget buildCheckoutTermsText() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 6.wp),
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 8.sp, color: Colors.grey[600], height: 1.5),
        children: [
          // TextSpan(text: "By continuing, you agree to our "),
          // TextSpan(
          //   text: "Terms and Conditions",
          //   style: TextStyle(
          //     color: Colors.blue.shade600,
          //     fontWeight: FontWeight.bold,
          //     decoration: TextDecoration.underline,
          //   ),
          // ),
          // TextSpan(text: " and "),
          // TextSpan(
          //   text: "Privacy Policy",
          //   style: TextStyle(
          //     color: Colors.blue.shade600,
          //     fontWeight: FontWeight.bold,
          //     decoration: TextDecoration.underline,
          //   ),
          // ),
        ],
      ),
    ),
  );
}
