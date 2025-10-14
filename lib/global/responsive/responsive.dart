import 'package:get/get.dart';

//create a extension named PercentSized for num type
extension PercentSized on num {
  double get hp => (Get.height * (this / 100));
  double get wp => (Get.width * (this / 100));
  double get sp => Get.width / 100 * (this / 3);
}
