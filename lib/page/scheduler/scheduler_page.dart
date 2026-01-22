import 'package:eventjar/controller/scheduler/controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class SchedulerPage extends GetView<SchedulerController> {
  const SchedulerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("Scheduler");
  }
}
