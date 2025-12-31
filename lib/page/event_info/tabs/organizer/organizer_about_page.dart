import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

Widget buildAboutSection(String bio) {
  return Text(
    bio,
    style: TextStyle(fontSize: 8.sp, color: Colors.grey[600], height: 1.5),
  );
}
