import 'package:eventjar/controller/profile_form/summary/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SummaryFormPage extends GetView<SummaryFormController> {
  const SummaryFormPage({super.key});

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
