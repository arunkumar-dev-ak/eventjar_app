import 'package:eventjar/model/set_2fa/set_2fa_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Set2faState {
  RxBool isLoading = false.obs;
  RxBool isOtpValid = false.obs;
  RxString step = 'generate'.obs; // generate | verify | complete

  Rxn<Generate2FAResponse> secretData = Rxn();

  RxList<String> otp = List.generate(6, (_) => '').obs;

  RxString error = ''.obs;
}
