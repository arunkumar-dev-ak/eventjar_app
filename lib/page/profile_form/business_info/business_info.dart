import 'package:eventjar/controller/profile_form/business_info/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessInfoPage extends GetView<BusinessInfoFormController> {
  const BusinessInfoPage({super.key});

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
      body: Text("hi"),
    );
  }
}
