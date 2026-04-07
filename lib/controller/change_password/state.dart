import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ChangePasswordState {
  final RxBool isLoading = true.obs;

  final RxBool isCurrentPwdVisible = false.obs;
  final RxBool isNewPwdVisible = false.obs;
  final RxBool isConfirmPwdVisible = false.obs;
}
