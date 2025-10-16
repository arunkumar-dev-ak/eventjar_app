import 'package:eventjar_app/controller/home/controller.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeContent extends StatelessWidget {
  final HomeController controller = Get.find();

  HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 100.wp,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Text("hello"),
      ),
    );
  }
}
