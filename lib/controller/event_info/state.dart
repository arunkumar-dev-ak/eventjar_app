import 'package:eventjar_app/model/event_info/event_info_model.dart';
import 'package:get/get.dart';

class EventInfoState {
  RxBool isLoading = false.obs;

  Rxn<EventInfo> eventInfo = Rxn<EventInfo>();
}
