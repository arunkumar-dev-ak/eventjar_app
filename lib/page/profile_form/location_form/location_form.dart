import 'package:eventjar/controller/profile_form/location/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationFormPage extends GetView<LocationFormController> {
  const LocationFormPage({super.key});

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
      body: Text("hi"),
    );
  }
}
