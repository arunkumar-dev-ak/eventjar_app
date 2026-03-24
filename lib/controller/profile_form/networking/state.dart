import 'package:get/get.dart';

class NetworkingFormState {
  final RxBool isLoading = false.obs;

  RxString selectedNetworkingGoal = ''.obs;
  RxList<String> selectedConnectionTypes = <String>[].obs;
  RxList<String> selectedHelpOfferings = <String>[].obs;
  RxList<String> selectedDiscussionTopics = <String>[].obs;
}
