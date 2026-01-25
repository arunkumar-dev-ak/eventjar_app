import 'package:eventjar/controller/meeting/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class MeetingPage extends GetView<MeetingController> {
  const MeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Text("In Meeting Page"),
    );
  }
}
