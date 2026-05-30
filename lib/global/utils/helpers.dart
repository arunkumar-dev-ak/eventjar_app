import 'package:eventjar/global/global_values.dart';

String getFileUrl(String imageUrl) {
  if (imageUrl.startsWith('http') || imageUrl.contains('cdn.myeventjar.com')) {
    return imageUrl;
  }
  return '${backendBaseUrl()}$imageUrl';
}

String capitalize(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}

String capitalizeName(String name) {
  if (name.isEmpty) return name;
  return name.split(' ').map((word) {
    if (word.isEmpty) return word;
    if (word.contains('.')) {
      return word.split('.').map((part) {
        if (part.isEmpty) return part;
        return part[0].toUpperCase() + part.substring(1).toLowerCase();
      }).join('.');
    }
    return capitalize(word);
  }).join(' ');
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
