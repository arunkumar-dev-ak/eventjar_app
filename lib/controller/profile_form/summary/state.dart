import 'package:get/get.dart';

class SummaryFormState {
  final RxBool isLoading = false.obs;

  final RxString shortBio = ''.obs;

  final List experienceRanges = [
    '0-1 years',
    '2-5 years',
    '6-10 years',
    '11-15 years',
    '16-20 years',
    '20+ years',
  ];
  final RxString experienceRange = '0-1 years'.obs;
}
