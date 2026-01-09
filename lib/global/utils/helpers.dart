import 'package:eventjar/global/global_values.dart';

String getFileUrl(String imageUrl) {
  return '${backendBaseUrl()}$imageUrl';
}

String capitalize(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}

DateTime? parseDateSafe(dynamic value) {
  if (value == null) return null;

  if (value is String && value.trim().isEmpty) {
    return null;
  }

  try {
    return DateTime.parse(value.toString());
  } catch (_) {
    return null;
  }
}
