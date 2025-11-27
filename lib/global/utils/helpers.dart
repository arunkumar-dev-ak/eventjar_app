import 'package:eventjar/global/global_values.dart';

String getFileUrl(String imageUrl) {
  return '${backendBaseUrl()}$imageUrl';
}

String capitalize(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}
